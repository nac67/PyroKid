package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.net.FileReference;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.graphics.Camera.CameraController;
    import pyrokid.tools.*;
    import pyrokid.LevelEditor;
    import pyrokid.dev.LevelEditor;
    import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import ui.playstates.BasePlayState;
	import ui.playstates.PauseMenu;
	import ui.playstates.StateController;
    import ui.playstates.LevelSelect;
    
    public class GameController extends Sprite {
        
        public var editorMode:Boolean = false;
        private var levelEditor:pyrokid.LevelEditor;
        
        private var playerWon:Boolean = false;
        
        // Camera for the level
        private var camera:Camera;
        private var cameraController:CameraController;
        public var level:Level;
        
		private var isPaused:Boolean = false;
		private var pauseMenu:BasePlayState;
        
        private var curLevelNum:int;
		
        /* levelRecipe is not specified if you want to load from browser
         * Otherwise give it a byte array from an embedded level file */
        public function GameController(level:Object = null, levelNum:int = -1) {
            curLevelNum = levelNum;
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
        
        public function destroy(logLeave:Boolean = true):void {
            if (logLeave) {
                var pCenter:Vector2i = level.player.getCenter();
                Main.log.logDeath(Utils.realToCell(pCenter.x), Utils.realToCell(pCenter.y), Constants.DEATH_BY_RESTART, level.frameCount);
            }
            Main.log.logEndLevel();
            Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            removeEventListener(Event.ENTER_FRAME, update);
        }
        
        private function initializeLevelAndEditor(levelRecipe:Object):void {
            reloadLevel(levelRecipe);
            levelEditor = new pyrokid.LevelEditor(level);
            //addChild(new pyrokid.dev.LevelEditor(level));
            levelEditor.reloadLevel = reloadLevel;
            addChild(levelEditor);
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        public function reloadLevel(levelRecipe):void {
            if (level != null) {
                removeChild(camera);
            }
            level = new Level(levelRecipe, curLevelNum);
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
            if (e.keyCode == Keyboard.ENTER && Constants.LEVEL_EDITOR_ENABLED) {
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
                if (e.keyCode == Keyboard.O) { //o
                    trace("loading level");
                    LevelIO.loadLevel(reloadLevel);
                } else if (e.keyCode == Keyboard.P) { //p
                    trace("saving level");
                    LevelIO.saveLevel(level.recipe);
                }
            } else {
                if (e.keyCode == Keyboard.R) {
                    var pCenter:Vector2i = level.player.getCenter();
                    Main.log.logDeath(Utils.realToCell(pCenter.x), Utils.realToCell(pCenter.y), Constants.DEATH_BY_RESTART, level.frameCount);
                    Main.log.logEndLevel();
                    restartLevel();
                }
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
                level.player.kill(level, null, Constants.DEATH_BY_FALLING);
            }
        }
        
        private function restartLevel():void {
            editorMode = false;
            reloadLevel(level.recipe);
        }
        
        private function centerOnPlayer(dt:Number):void {
            // Focus On The Player
            var focus:Vector2 = new Vector2(level.player.x, level.player.y);

            // Zoom Out Based On Velocity
            var cZoom:Number = 1.0;
            if (Constants.PLAYER_MOVE_ZOOM) {
                cZoom = level.player.velocity.length / 100.0;
                cZoom = 1.0 / Math.max(0.8, Math.min(1.0, cZoom));
            }
            
            // Update Camera
            cameraController.update(focus, level, new Point(0, 0), new Point(level.cellWidth * Constants.CELL, level.cellHeight * Constants.CELL), dt, cZoom);
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
                if (rect.sprite is Exit) {
                    var exit:Exit =  rect.sprite as Exit;
                    if (exit.isHole) { // TODO this code sucks -- Aaron
                        continue;
                    }
                }
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
                            // TODO -- Aaron, exit can be bomb or hole
                        }
                    } else {
                        level.player.damageFromEnemyContact(level);
                    }
                }
            }
        }
        
        private function executeClipsAndDelayedFunctions():void {
            level.briefClips.filter(function(o:Object):Boolean {
               var mc:BriefClip = o as BriefClip;
               if (mc.clip is Embedded.FireballFizzSWF) {
                   Utils.moveInDirFacing(mc, Constants.FBALL_SPEED / 2);
               }
               return !mc.update();
            });
            var newDelayedFunctions:Dictionary = new Dictionary();
            for (var o:Object in level.delayedFunctions) {
                var func:Function = o as Function;
                var framesLeft:int = level.delayedFunctions[func];
                if (framesLeft <= 0) {
                    func();
                } else {
                    newDelayedFunctions[func] = framesLeft - 1;
                }
            }
            level.delayedFunctions = newDelayedFunctions;
        }
        
        // --------------------MAIN UPDATE LOOP-------------------- //
        private function update(event:Event):void {
            if (editorMode || isPaused) {
                return;
            }
            // ---------------------- Game Lose Conditions -------------------- //
            if (level.gameOverState == Constants.GAME_OVER_FADING) {
                executeClipsAndDelayedFunctions();
                if (level.gameOverState == Constants.GAME_OVER_COMPLETE) {
                    restartLevel();
                }
                return;
            }
            
            level.frameCount += 1;
            level.dirty = false;
            
            // ------------------------- Game logic ------------------------ //
            level.player.update(level);
            for each (var enemy:FreeEntity in level.enemies) {
                enemy.update(level);
            }
            level.projectileUpdate();
            FireHandler.spreadFire(level);
            // -------------------------- Physics --------------------------- //
            handlePhysics();
            resolveFreeEntityCollisions();
            
            // ------------------------ After physics game logic ------------ //
            processMovingTilesInGrid();
            killPlayerIfOffMap(level);
            
            // --------------------------- Visuals -------------------------- //
            centerOnPlayer(Constants.DT);
            executeClipsAndDelayedFunctions();

            level.removeDead();
            // ---------------------- Game Win Conditions -------------------- //
            if (playerWon) {
                LevelSelect.startAndSetLevel(LevelSelect.currLevel + 1, true)();
            }
        }
    
    }

}