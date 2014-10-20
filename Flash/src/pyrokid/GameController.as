package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.net.FileReference;
    import flash.events.KeyboardEvent;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    import flash.ui.Keyboard;
    
    public class GameController extends Sprite {
        
        public var editorMode:Boolean = false;
        private var levelEditor:LevelEditor;
        
        // Camera for the level
        private var camera:Camera;
        
        public var level:Level;
        
        public var isGameOver:Boolean = false;
        public var createGameOverScreenFunc:Function;
        
        /* levelRecipe is not specified if you want to load from browser
         * Otherwise give it a byte array from an embedded level file */
        public function GameController(levelBytes:ByteArray = null) {
            Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            
            if (levelBytes == null) {
                // Load level with browser
                LevelIO.loadLevel(initializeLevelAndEditor);
            } else {
                // Load embedded level
                levelBytes.position = 0;
                initializeLevelAndEditor(levelBytes.readObject());
            }
        }
        
        public function destroy():void {
            Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            removeEventListener(Event.ENTER_FRAME, update);
        }
        
        private function initializeLevelAndEditor(levelRecipe:Object):void {
            reloadLevel(levelRecipe);
            levelEditor = new LevelEditor(level);
            levelEditor.reloadLevel = reloadLevel;
            addChild(levelEditor);
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        public function reloadLevel(levelRecipe):void {
            if (level != null) {
                removeChild(camera);
            }
            level = new Level(levelRecipe);
            camera = new Camera(level);
            addChild(camera);
            setChildIndex(camera, 0);
            if (editorMode) {
                levelEditor.loadLevel(level);
            }
            Main.MainStage.focus = camera;
        }
        
        private function levelEditorListener(e:KeyboardEvent):void {
            if (e.keyCode == 13) { //enter
                editorMode = !editorMode;
                if (editorMode) {
                    levelEditor.turnEditorOn();
                } else {
                    levelEditor.turnEditorOff();
                    level.frameCount = 0;
                }
                reloadLevel(level.recipe);
            }
            
            if (editorMode) {
                if (e.keyCode == 79) { //o
                    trace("loading level");
                    LevelIO.loadLevel(reloadLevel);
                } else if (e.keyCode == 80) { //p
                    trace("saving level");
                    LevelIO.saveLevel(level.recipe);
                }
            } else {
                
            }
        }
        
        private function keyboardActionListener(e:KeyboardEvent):void {
            if (e.keyCode == Keyboard.ESCAPE) {
                doGameOver();
            }
        }
        
        private function checkGameOver(over:Boolean):void {
            if (over) {
                doGameOver();
                return;
            }
            if (level.player.y > stage.stageHeight + 500) {
                trace("fell to your doom, bitch");
                doGameOver();
                return;
            }
            
            if (level.player.x > stage.stageWidth) {
                doGameWon();
            }
        }
        
        private function doGameOver():void {
            destroy();
            isGameOver = true;
            createGameOverScreenFunc(false);
        }
        private function doGameWon():void {
            destroy();
            isGameOver = true;
            createGameOverScreenFunc(true);
        }
        
        private function centerOnPlayer():void {
            camera.xCamera = Utils.lerp(camera.xCamera, level.player.x, Constants.CAMERA_LAG);
            camera.yCamera = Utils.lerp(camera.yCamera, level.player.y, Constants.CAMERA_LAG);
            camera.x = Constants.WIDTH / 2;
            camera.y = Constants.HEIGHT / 2;
        }
        
        private function handlePhysics():void {
            // calculate new positions of islands
            ViewPIsland.updatePhysics(level.islands, level.columns, Constants.GRAVITY_VECTOR);
            
            // Make sprites islands match physics islands
            for each (var island:ViewPIsland in level.islandViews) {
                island.onUpdate();
            }
            
            // update new positions of dynamic objects and update sprite stuff sequentially
            for each (var rect:ViewPRect in level.rectViews) {
                rect.onUpdate(level.islands, rect.sprite.resolveCollision, rect.sprite.collisionCallback);
            }
        }
        
        // TODO TODO TODO
        private function processMovingTilesInGrid():void {
            for each (var islandView:ViewPIsland in level.islandViews) {
                if (islandView.sprite.isMoving() && level.movingTiles.indexOf(islandView) == -1) {
                    for each (var entity:TileEntity in islandView.sprite.entityList) {
                        for each (var cell:Vector2i in entity.cells) {
                            var cellY:int = cell.y + Math.round(entity.getGlobalAnchor().y);
                            var cellX:int = cell.x + Math.round(entity.getGlobalAnchor().x);
                            level.tileEntityGrid[cellY][cellX] = null;
                        }
                    }
                    level.movingTiles.push(islandView);
                }
            }
            level.movingTiles = level.movingTiles.filter(function(islandView) {
                if (!islandView.sprite.isMoving()) {
                    for each (var entity:TileEntity in islandView.sprite.entityList) {
                        for each (var cell:Vector2i in entity.cells) {
                            var cellY:int = cell.y + Math.round(entity.getGlobalAnchor().y);
                            var cellX:int = cell.x + Math.round(entity.getGlobalAnchor().x);
                            level.tileEntityGrid[cellY][cellX] = entity;
                        }
                    }
                    return false;
                } else {
                    return true;
                }
            });
        }
        
        /* Returns true if the player died. */
        private function resolveFreeEntityCollisions():Boolean {
            var playerDead:Boolean = false;
            for (var i:int = 0; i < level.enemies.length; i++) {
                for (var j:int = i + 1; j < level.enemies.length; j++) {
                    if (level.enemies[i].isTouching(level.enemies[j])) {
                        level.enemies[i].mutualIgnite(level, level.enemies[j]);
                    }
                }
                if (level.player.isTouching(level.enemies[i])) {
                    if (Constants.GOD_MODE) {
                        level.player.mutualIgnite(level, level.enemies[i]);
                    } else {
                        playerDead = true;
                    }
                }
            }
            return playerDead;
        }
        
        private function update(event:Event):void {
            if (editorMode) {
                return;
            }
            level.frameCount += 1;
            level.dirty = false;
            //camera.rotationCamera += 0.1;
            //camera.scaleCamera(1.001);
            
            // ------------------------- Game logic ------------------------ //
            level.player.update(level);
            for each (var spider in level.enemies) {
                spider.update();
            }
            level.fireballUpdate();
            FireHandler.spreadFire(level);
            
            // -------------------------- Physics --------------------------- //
            handlePhysics();
            var playerDied:Boolean = resolveFreeEntityCollisions();
            
            // ------------------------ After physics game logic ------------ //
            processMovingTilesInGrid();
            level.removeDead();
            
            // --------------------------- Visuals -------------------------- //
            centerOnPlayer();
            level.briefClips.filter(function(o:Object):Boolean {
               var mc:MovieClip = o as MovieClip;
               if (mc is Embedded.FireballFizzSWF) {
                   Utils.moveInDirFacing(mc, Constants.FBALL_SPEED / 2);
               }
               return mc.currentFrame != mc.totalFrames;
            });

            // ---------------------- End Game Conditions -------------------- //
            checkGameOver(playerDied);
        }
    
    }

}