package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
	import physics.*;
	
	public class GameController extends Sprite {
		
        public var editorMode:Boolean = false;
		private var levelEditor:LevelEditor;
        
		public var level:Level;
        
        private var buf:RingBuffer;
        
        // TODO move these somewhere logical
        private var prevFrameFireBtn:Boolean = false;
        private var prevFrameJumpBtn:Boolean = false;
		
		// TODO remove
        private var isPlayerGrounded:Boolean = false;
		
		public function GameController() {
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            LevelIO.loadLevel(function(levelRecipe):void {
				reloadLevel(levelRecipe);
				levelEditor = new LevelEditor(level);
				addChild(levelEditor);
				addEventListener(Event.ENTER_FRAME, update);
			});
            
            var buf:RingBuffer = new RingBuffer(5);
            buf
            buf.push("a");
            buf.push("b");
            buf.push("c");
            buf.push("d");
            buf.push("e");
            buf.push("FFFF");
            trace(buf.buffer);
            //buf.preparePurge("c");
            //buf.preparePurge("e");
            //buf.purgeThoseWhichArePrepared();
            
            buf.filter(function(item) {
               return !(item == "c" ||  item == "e");
            });
            
            trace(buf.buffer);
		}

		public function reloadLevel(levelRecipe):void {
			if (level != null) {
				removeChild(level);
			}
			level = new Level(levelRecipe);
			addChild(level);
			if (editorMode) {
				levelEditor.loadLevel(level);
			}
		}
		
		private function levelEditorListener(e:KeyboardEvent):void {
            if (e.keyCode == 13) { //enter
                editorMode = !editorMode;
				if (editorMode) {
					levelEditor.turnEditorOn();
				} else {
					levelEditor.turnEditorOff();
				}
                reloadLevel(level.recipe);
            }
            
            if (editorMode){
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
		
        public function resolveCollision(r:GameEntity, a:CollisionAccumulator):Boolean {
            if (a.accumNY > 0) {
                isPlayerGrounded = true;
            }
            return true;
        }
		    
        private function update(event:Event):void {
			if (!editorMode) {
				
				
				var dt:Number = 1 / 30.0;
				level.player.velocity.Add(0, 9 * dt);
				level.player.velocity.x = 0;
				if (Key.isDown(Constants.LEFT_BTN)) {
					level.player.velocity.x -= 2;
                    level.player.direction = Constants.DIR_LEFT;
                    level.player.animIsRunning = true;
				} else if (Key.isDown(Constants.RIGHT_BTN)) {
					level.player.velocity.x += 2;
                    level.player.direction = Constants.DIR_RIGHT;
                    level.player.animIsRunning = true;
				} else {
                    level.player.animIsRunning = false;                    
                }
				if (isPlayerGrounded && Key.isDown(Constants.JUMP_BTN) && !prevFrameJumpBtn) {
					level.player.velocity.y = -6;
				}
                prevFrameJumpBtn = Key.isDown(Constants.JUMP_BTN);
				level.player.Update(dt);
                level.player.updateAnimation(isPlayerGrounded);
				isPlayerGrounded = false;
				CollisionResolver.Resolve(level.player, level.islands, resolveCollision);
                
                if (Key.isDown(Constants.FIRE_BTN) && !prevFrameFireBtn) {
                    // Fire button just pressed
                    level.player.fireballCharge = 0;
                    level.player.isCharging = true;
                }else if (Key.isDown(Constants.FIRE_BTN)) {
                    // Fire button is being held
                    level.player.fireballCharge++;
                }else if(prevFrameFireBtn) {
                    // Fire button is released
                    level.player.isCharging = false;
                    level.player.isShooting = true;
                    if (level.player.fireballCharge > Constants.FIREBALL_CHARGE) {
                        launchFireball();
                    }else {
                        launchSpark();
                    }
                }
                prevFrameFireBtn = Key.isDown(Constants.FIRE_BTN);
				
				/*
				if (Math.random() < 0.05) {
					var fireGrid:Array = [];
					var onFire:Array = [];
					for (var y:int = 0; y < level.staticObjects.length; y++) {
						fireGrid.push(new Array(level.staticObjects[0].length));
						for (var x:int = 0; x < level.staticObjects[0].length; x++) {
							var box = level.staticObjects[y][x];
							if (box != null) {
								fireGrid[y][x] = box.fire;
								if (box.fire.isOnFire()) {
									onFire.push(box.fire);
								}
							}
						}
					}
					Fire.spreadFire(onFire, fireGrid);
				}*/
                
                
                //fireballs
                for (var i = 0; i < level.fireballs.size(); i++) {
                    var fball:Fireball = level.fireballs.get(i) as Fireball;
                    fball.x += fball.speedX;
                    var cellX = CoordinateHelper.realToCell(fball.x);
                    var cellY = CoordinateHelper.realToCell(fball.y);
                    var entity:GameEntity;
                    try{
                        entity = level.staticObjects[cellY][cellX];
                    } catch (exc) {
                        entity = null;
                    }
                    if (entity != null) {
                        // remove fireball from list, also delete from stage
                        level.fireballs.markForDeletion(fball);
                    }
                }
                level.fireballs.deleteAllMarked();
                
                
                //firesplooshes
                for (var i = 0; i < level.firesplooshes.size(); i++) {
                    var fsploosh:MovieClip = level.firesplooshes.get(i) as MovieClip;
                    if (fsploosh.currentFrame == fsploosh.totalFrames) {
                        level.firesplooshes.markForDeletion(fsploosh);
                    }
                }
                level.firesplooshes.deleteAllMarked();
                
                level.x = Math.floor(- level.player.x + 400);
				
            }
        }
        
        function launchFireball() {
            var fball:Fireball = new Fireball();
            fball.x = level.player.x+25;
            fball.y = level.player.y+25;
            fball.speedX = (level.player.direction == Constants.DIR_LEFT ? -Constants.FBALL_SPEED : Constants.FBALL_SPEED);
            level.fireballs.push(fball);
            level.addChild(fball);
        }
        
        function launchSpark() {
            var spark:MovieClip = new Embedded.FiresplooshSWF();
            spark.x = level.player.x + 25;
            spark.y = level.player.y + 25;
            level.firesplooshes.push(spark);
            level.addChild(spark);
        }
		
	}
	
}