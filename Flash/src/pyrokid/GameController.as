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
	import ui.LevelsInfo;
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
        private var largeZoom:Number = 1.0;
        public var level:Level;
        public var spotlight:Spotlight;
        
		public var isPaused:Boolean = false;
		private var pauseMenu:BasePlayState;
        
        private var curLevelNum:int;
        
        private var benchmarker:Benchmarker;
		
        /* level is not specified if you want to start a new level in the level editor
         * Otherwise give it a byte array from an embedded level file */
        public function GameController(level:Object = null, levelNum:int = -1) {
            benchmarker = new Benchmarker(["PHYSICS", "FIRE", "BETWEEN UPDATES"]);
            curLevelNum = levelNum;
            Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            
            if (level == null) {
                // Load new level with browser
                //LevelIO.loadLevel(initializeLevelAndEditor);
                initializeLevelAndEditor(LevelRecipe.generateTemplate());
                editorMode = true;
                levelEditor.turnEditorOn();
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
            if (spotlight != null && this.contains(spotlight)) {
                this.removeChild(spotlight);
            }
            level = new Level(levelRecipe, curLevelNum);
            camera = new Camera(level);
            addChild(camera);
            setChildIndex(camera, 0);
            
            spotlight = new Spotlight();
            addChild(spotlight);
            //spotlight.visible = false;
            
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
			if ((e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.P) && !editorMode) {
				if (isPaused) { //unpause game
					pauseMenu.removeAllEventListeners();
					Utils.removeAllChildren(pauseMenu);
					removeChild(pauseMenu);
				} else { //pause the game
					pauseMenu = new PauseMenu(this);
					addChild(pauseMenu);
				}
				isPaused = !isPaused;
			}
        }
        
        private function killPlayerIfOffMap(level:Level):void {
            if (level.player.y > level.worldHeight + Constants.FALL_TO_DEATH_HEIGHT) {
                var fireFromBottom:BriefClip = new BriefClip(new Vector2(level.player.x, level.player.y), new Embedded.FireTileSWF() as MovieClip, new Vector2(), Constants.FADE_TIME, true, Constants.DEATH_CLIP_TYPE_FIRE);
                level.player.kill(level, fireFromBottom, Constants.DEATH_BY_FALLING);
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
            
            if (Key.isDown(Keyboard.SPACE)) {
                var min:Point = level.localToGlobal(new Point(0, 0));
                var max:Point = level.localToGlobal(new Point(level.worldWidth, level.worldHeight));
                
                if (max.x <= (Constants.WIDTH + 5) &&
                    max.y <= (Constants.HEIGHT + 5) &&
                    min.x >= -5 &&
                    min.y >= -5
                    ) {
                }
                else {
                    largeZoom *= 0.99;
                }
            }
            else {
                largeZoom = Utils.lerp(largeZoom, 1.0, 0.9);
            }
            cZoom *= largeZoom;
            
            // Update Camera
            cameraController.update(focus, level, new Point(0, 0), new Point(level.cellWidth * Constants.CELL, level.cellHeight * Constants.CELL), dt, cZoom);
            
            // Place spotlight
            var playerPos:Point;
            if (level.smooshedPlayer == null) {
                playerPos = new Point(level.player.getCenter().x, level.player.getCenter().y);
            } else {
                playerPos = new Point(level.smooshedPlayer.x, level.smooshedPlayer.y);
            }
            playerPos = level.localToGlobal(playerPos);
            playerPos.y = Math.min(playerPos.y, Constants.HEIGHT);
            spotlight.x = playerPos.x;
            spotlight.y = playerPos.y;
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
            benchmarker.endPhase();
            benchmarker.endFrame();
            benchmarker.beginFrame();
            spotlight.visible = !editorMode && !isPaused;
            if (editorMode || isPaused) {
                return;
            }
            
            // ---------------------- Universal Visuals ----------------------//
            centerOnPlayer(Constants.DT);
            spotlight.step();
            
            // ---------------------- Game Lose Conditions -------------------- //
            if (level.gameOverState == Constants.GAME_OVER_FADING) {
                spotlight.shrink = true;
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
            benchmarker.beginPhase("FIRE");
            FireHandler.spreadFire(level);
            benchmarker.endPhase();
            // -------------------------- Physics --------------------------- //
            benchmarker.beginPhase("PHYSICS");
            handlePhysics();
            benchmarker.endPhase();
            resolveFreeEntityCollisions();
            
            // ------------------------ After physics game logic ------------ //
            processMovingTilesInGrid();
            killPlayerIfOffMap(level);
            
            // --------------------------- Visuals -------------------------- //
            executeClipsAndDelayedFunctions();

            level.removeDead();
            // ---------------------- Game Win Conditions -------------------- //
            if (playerWon) {
				LevelsInfo.checkAndUnlockNextLevel();
                LevelSelect.startAndSetLevel(LevelsInfo.currLevel + 1, true)();
            }
            benchmarker.beginPhase("BETWEEN UPDATES");
        }
    
    }

}