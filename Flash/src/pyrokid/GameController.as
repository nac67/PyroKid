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
        public var hasPlayerWon:Boolean = false;
        public var createGameOverScreenFunc:Function;
        
        /* levelRecipe is not specified if you want to load from browser
         * Otherwise give it a byte array from an embedded level file */
        public function init(levelBytes:ByteArray = null):void {
            if (levelBytes == null) {
                // Load level with browser
                LevelIO.loadLevel(initializeLevelAndEditor);
            } else {
                // Load embedded level
                levelBytes.position = 0;
                initializeLevelAndEditor(levelBytes.readObject());
            }
        }
        
        private function begin():void {
            stage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            addEventListener(Event.ENTER_FRAME, update);
        }
        public function destroy():void {
            stage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            removeEventListener(Event.ENTER_FRAME, update);
        }
        
        private function initializeLevelAndEditor(levelRecipe:Object):void {
            reloadLevel(levelRecipe);
            addChild(level);
            begin();
        }
        
        public function reloadLevel(levelRecipe:Object):void {
            if (level != null) {
                removeChild(camera);
            }
            level = new Level(levelRecipe);
            camera = new Camera(level);
            addChild(camera);
            camera.x = Constants.WIDTH / 2;
            camera.y = Constants.HEIGHT / 2;
            setChildIndex(camera, 0);
            stage.focus = camera;
            if (editorMode) {
                levelEditor.loadLevel(level);
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
            hasPlayerWon = false;
        }
        private function doGameWon():void {
            destroy();
            isGameOver = true;
            hasPlayerWon = true;
        }
        
        private function centerOnPlayer():void {
            // TODO: FIX THIS, WTF?
            camera.xCamera = Utils.lerp(camera.xCamera, level.player.x - Constants.WIDTH / 2, Constants.CAMERA_LAG);
            camera.yCamera = Utils.lerp(camera.yCamera, level.player.y - Constants.HEIGHT / 2, Constants.CAMERA_LAG);
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
        
        private function processMovingTilesInGrid():void {
            for each (var islandView:ViewPIsland in level.islandViews) {
                //TODO: should this be equals 0? Ask Cristian if physics is precise enough
                if (islandView.sprite.isMoving()) {
                    if (level.movingTiles.indexOf(islandView) == -1) {
                        for each (var cell:Vector2i in islandView.sprite.cells) {
                            var cellY:int = cell.y + Math.floor(islandView.sprite.globalAnchor.y);
                            var cellX:int = cell.x + Math.floor(islandView.sprite.globalAnchor.x);
                            level.tileEntityGrid[cellY][cellX] = null;
                        }
                        level.movingTiles.push(islandView);
                    }
                }
            }
            level.movingTiles = level.movingTiles.filter(function(islandView:ViewPIsland, i:int, a:Array):Boolean {
                if (!islandView.sprite.isMoving()) {
                    for each (var cell:Vector2i in islandView.sprite.cells) {
                        var cellY:int = cell.y + Math.round(islandView.sprite.globalAnchor.y);
                        var cellX:int = cell.x + Math.round(islandView.sprite.globalAnchor.x);
                        level.tileEntityGrid[cellY][cellX] = islandView.sprite;
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
            for each (var spider:Spider in level.enemies) {
                spider.update();
            }
            level.fireballUpdate();
            FireHandler.spreadFire(level);
            processMovingTilesInGrid();
            
            // -------------------------- Physics --------------------------- //
            handlePhysics();
            var playerDied:Boolean = resolveFreeEntityCollisions();
            
            // ------------------------ After physics game logic ------------ //
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