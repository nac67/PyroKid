package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.net.FileReference;
    import flash.events.KeyboardEvent;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.graphics.Camera.CameraController;
    import pyrokid.tools.*;
    import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import ui.playstates.BasePlayState;
	import ui.playstates.PauseMenu;
	import ui.playstates.StateController;
    import ui.playstates.LevelSelect;
    
    public class GameController extends Sprite {
        
        public var editorMode:Boolean = false;
        private var levelEditor:LevelEditor;
        
        private var playerDied:Boolean = false;
        private var playerWon:Boolean = false;
        
        // Camera for the level
        private var camera:Camera;
        private var cameraController:CameraController;
        public var level:Level;
        
		private var isPaused:Boolean = false;
		private var pauseMenu:BasePlayState;
		
        /* levelRecipe is not specified if you want to load from browser
         * Otherwise give it a byte array from an embedded level file */
        public function GameController(level:Object = null) {
            Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            
            if (level == null) {
                // Load level with browser
                LevelIO.loadLevel(initializeLevelAndEditor);
            } else if (level is ByteArray) {
                // Load embedded level
                level.position = 0;
                initializeLevelAndEditor(level.readObject());
			} else if (level is LevelRecipe) {
				initializeLevelAndEditor(level);
			}
        }
        
        public function destroy():void {
            Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
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
            cameraController = new CameraController(camera, null);
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
                StateController.goToMainMenu();
            }
			if (e.keyCode == Keyboard.SHIFT) {
				if (isPaused) { //unpause game
					pauseMenu.removeAllEventListeners();
					removeChild(pauseMenu);
				} else { //pause the game
					pauseMenu = new PauseMenu();
					addChild(pauseMenu);
				}
				isPaused = !isPaused;
			}
        }
        
        private function killPlayerIfOffMap(level:Level):void {
            if (level.player.y > stage.stageHeight + 500) {
                level.player.kill(level);
            }
        }
        
        private function fadeAndRestart():void {
            playerDied = false;
            editorMode = false;
            reloadLevel(level.recipe);
        }
        
        private function centerOnPlayer(dt:Number):void {
            var minX:int = Constants.WIDTH / 2;
            var minY:int = Constants.HEIGHT / 2;
            var maxX:int = level.numCellsWide * Constants.CELL - Constants.WIDTH / 2;
            var maxY:int = level.numCellsTall * Constants.CELL - Constants.HEIGHT / 2;
                        
            var focus:Vector2 = new Vector2(level.player.x, level.player.y);
            focus.x = Math.max(minX, Math.min(maxX, focus.x));
            focus.y = Math.max(minY, Math.min(maxY, focus.y));
            
            cameraController.update(focus, dt);
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
        
        private function resolveFreeEntityCollisions():void {
            var playerDead:Boolean = false;
            for (var i:int = 0; i < level.enemies.length; i++) {
                for (var j:int = i + 1; j < level.enemies.length; j++) {
                    if (level.enemies[i].isTouching(level.enemies[j])) {
                        level.enemies[i].mutualIgnite(level, level.enemies[j]);
                    }
                }
                if (level.player.isTouching(level.enemies[i])) {
                    level.player.mutualIgnite(level, level.enemies[i]);
                    if (level.enemies[i] is Exit) {
                        if (level.enemies[i].canExit()) {
                            playerWon = true;
                        }
                    } else {
                        level.player.damageFromEnemyContact(level);
                    }
                }
            }
        }
        
        // --------------------MAIN UPDATE LOOP-------------------- //
        private function update(event:Event):void {
            if (editorMode || isPaused) {
                return;
            }
            level.frameCount += 1;
            level.dirty = false;
            
            // ------------------------- Game logic ------------------------ //
            level.player.update(level);
            for each (var enemy:FreeEntity in level.enemies) {
                enemy.update(level);
            }
            level.fireballUpdate();
            FireHandler.spreadFire(level);
            // -------------------------- Physics --------------------------- //
            handlePhysics();
            resolveFreeEntityCollisions();
            
            // ------------------------ After physics game logic ------------ //
            processMovingTilesInGrid();
            killPlayerIfOffMap(level);
            
            // --------------------------- Visuals -------------------------- //
            centerOnPlayer(Constants.DT);
            level.briefClips.filter(function(o:Object):Boolean {
               var mc:BriefClip = o as BriefClip;
               if (mc.clip is Embedded.FireballFizzSWF) {
                   Utils.moveInDirFacing(mc, Constants.FBALL_SPEED / 2);
               }
               return !mc.update();
            });

            // ---------------------- End Game Conditions -------------------- //
            playerDied = level.removeDead();
            if (playerDied) {
                if (Constants.GOD_MODE) {
                    trace("you would have died!!!");
                } else {
                    fadeAndRestart();
                }
            }
            if (playerWon) {
                LevelSelect.startAndSetLevel(LevelSelect.currLevel + 1)();
            }
        }
    
    }

}