package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
	import physics.*;
	import pyrokid.entities.FreeEntity;
	import pyrokid.entities.TileEntity;
	import flash.ui.Keyboard;
	
	public class GameController extends Sprite {
		
        public var editorMode:Boolean = false;
		private var levelEditor:LevelEditor;
        
		public var level:Level;
        
        private var buf:RingBuffer;
        
        // TODO move these somewhere logical
        private var prevFrameFireBtn:Boolean = false;
        private var prevFrameJumpBtn:Boolean = false;
		
		// TODO reset to 0 when level editor turned off
		private var frameCount:int = 0;
		
		public var isGameOver:Boolean = false;
		public var createGameOverScreenFunc:Function;
		
		public function GameController() {
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            LevelIO.loadLevel(function(levelRecipe):void {
				reloadLevel(levelRecipe);
				levelEditor = new LevelEditor(level);
				addChild(levelEditor);
				addEventListener(Event.ENTER_FRAME, update);
			});
            
            //level = new Level(new LevelRecipe());
            //addChild(level);
            //addEventListener(Event.ENTER_FRAME, update);
		}

		public function reloadLevel(levelRecipe):void {
			if (level != null) {
				removeChild(level);
			}
			level = new Level(levelRecipe);
			addChild(level);
			setChildIndex(level, 0);
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
		
		private function fireballUpdate():void {
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
			

			//fireballs
			for (var i = 0; i < level.fireballs.size(); i++) {
				var fball:Fireball = level.fireballs.get(i) as Fireball;
				fball.x += fball.speedX;
				var cellX = CoordinateHelper.realToCell(fball.x);
				var cellY = CoordinateHelper.realToCell(fball.y);
				var entity:TileEntity;
				try {
					entity = level.tileEntityGrid[cellY][cellX];
				} catch (exc) {
					entity = null;
				}
				if (entity != null) {
					// remove fireball from list, also delete from stage
					level.fireballs.markForDeletion(fball);
					entity.ignite(level.onFire, frameCount);
				}
			}
			level.fireballs.deleteAllMarked();
			
            
            level.playerAttackObjects = level.playerAttackObjects.filter(function(o) {
               var pao:PlayerAttackObject = o as PlayerAttackObject;
               return !PlayerAttackObject.deleteThis(level, pao); 
            });
			
		}

		private function keyboardActionListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				isGameOver = true;
				createGameOverScreenFunc(false);
				trace("over");
				Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);

			}
		}
		    
        private function update(event:Event):void {
			if (editorMode) {
				return;
			}
			frameCount += 1;
			
			
			level.playerRect.velocity.Add(0, Constants.GRAVITY * Constants.dt);
			level.playerRect.velocity.x = 0;
			if (Key.isDown(Constants.LEFT_BTN)) {
				level.playerRect.velocity.x -= 2;
				level.player.direction = Constants.DIR_LEFT;
				level.player.animIsRunning = true;
			} else if (Key.isDown(Constants.RIGHT_BTN)) {
				level.playerRect.velocity.x += 2;
				level.player.direction = Constants.DIR_RIGHT;
				level.player.animIsRunning = true;
			} else {
				level.player.animIsRunning = false;                    
			}
			
			if (level.player.isGrounded && Key.isDown(Constants.JUMP_BTN) && !prevFrameJumpBtn) {
				level.playerRect.velocity.y = -6;
			}
			prevFrameJumpBtn = Key.isDown(Constants.JUMP_BTN);
			level.playerRect.Update(Constants.dt);
			level.player.updateAnimation(level.player.isGrounded, level.playerRect);
            
            fireballUpdate();
            
            //XXX spiders oh my!
            var spider:Spider = level.spiderView.sprite as Spider;
            spider.update(level.spiderView.phys);
            
            
            
            
            for (var i:int = 0; i < level.playerAttackObjects.length; i++) {
                var attackObj:PlayerAttackObject = level.playerAttackObjects[i] as PlayerAttackObject;
                for (var j:int = 0; j < level.spiderList.length; j++) {
                    var spider:Spider = level.spiderList[j] as Spider;
                    if(spider != null){
                        if (attackObj.collidingWith(spider)) {
                            if(attackObj.isFireball){
                                level.fireballs.remove(attackObj.fireballSprite);
                            }
                            level.removeChild(spider);
                            level.spiderList[i] = null;
                            var die = new Embedded.SpiderDieSWF();
                            die.x = spider.x;
                            die.y = spider.y-20;
                            die.scaleX = spider.scaleX;
                            die.scaleY = spider.scaleY;
                            level.addChild(die);
                            level.briefClips.push(die);
                        }
                    }
                }
            }
            
			
			
            
            //Brief Clips
            level.briefClips.filter(function(o:Object):Boolean {
               var mc:MovieClip = o as MovieClip;
               return mc.currentFrame != mc.totalFrames;
            });
            
			ViewPIsland.updatePhysics(level.islands, level.columns, new Vector2(0, 9), Constants.dt);
			for (var i:int = 0; i < level.islandViews.length; i++) {
				level.islandViews[i].onUpdate();
			}
			for (var i:int = 0; i < level.rectViews.length; i++) {
				level.rectViews[i].onUpdate(level.islands, Constants.dt, level.rectViews[i].sprite.resolveCollision);
			}
			
			if (frameCount % 30 == 0) {
				FireHandler.spreadFire(level.onFire, level.tileEntityGrid, frameCount);
			}
			level.x = Math.floor(level.x * Constants.CAMERA_LAG + (1 - Constants.CAMERA_LAG) * (-level.player.x + 400));
			level.y = Math.floor(level.y * Constants.CAMERA_LAG + (1 - Constants.CAMERA_LAG) * (-level.player.y + 300));
        }
        
        function launchFireball():void {
            var fball:Fireball = new Fireball();
            fball.x = level.player.x+ (level.player.direction == Constants.DIR_RIGHT ? 25 : 5);
            fball.y = level.player.y+25;
            fball.speedX = (level.player.direction == Constants.DIR_LEFT ? -Constants.FBALL_SPEED : Constants.FBALL_SPEED);
            level.fireballs.push(fball);
            level.addChild(fball);
            level.playerAttackObjects.push(new PlayerAttackObject(fball));
        }
        
        function launchSpark():void {
            var spark:MovieClip = new Embedded.FiresplooshSWF();
            spark.x = level.player.x + (level.player.direction == Constants.DIR_RIGHT ? 25 : 5);
            spark.y = level.player.y + 25;
            level.briefClips.push(spark);
            level.addChild(spark);
            level.playerAttackObjects.push(new PlayerAttackObject(null,new Vector2(spark.x, spark.y)));
        }
		
	}
	
}