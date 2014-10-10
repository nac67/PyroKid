package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
	import physics.*;
	import pyrokid.entities.*;
	import flash.ui.Keyboard;
	
	public class GameController extends Sprite {
		
        public var editorMode:Boolean = false;
		private var levelEditor:LevelEditor;
        
		public var level:Level;
        
        
        
		
		
		
		public var isGameOver:Boolean = false;
		public var createGameOverScreenFunc:Function;
		
		public function GameController(levelRecipe:ByteArray=null) {
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
            
            if(levelRecipe == null){
                LevelIO.loadLevel(function(levelRecipe):void {
                    reloadLevel(levelRecipe);
                    levelEditor = new LevelEditor(level);
                    addChild(levelEditor);
                    addEventListener(Event.ENTER_FRAME, update);
                });
            }else {
                reloadLevel(levelRecipe.readObject());
                levelRecipe.position = 0;
                levelEditor = new LevelEditor(level);
                addChild(levelEditor);
                addEventListener(Event.ENTER_FRAME, update);
            }
            
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
            Main.MainStage.focus = level;
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
		
		

		private function keyboardActionListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				doGameOver();
			}
		}
		
		private function doGameOver() {
			isGameOver = true;
			Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
			removeEventListener(Event.ENTER_FRAME, update);
			createGameOverScreenFunc(false);
		}
		private function doGameWon() {
			isGameOver = true;
			Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
			removeEventListener(Event.ENTER_FRAME, update);
			createGameOverScreenFunc(true);
		}
		    
        private function update(event:Event):void {
			if (editorMode) {
				return;
			}
			level.frameCount += 1;
			
			level.player.update(level);
            
            for each (var spider:Spider in level.spiderList) {
                if(spider != null) {
                    spider.update();
                }
            }
            
            
            for (var i:int = 0; i < level.fireballs.size(); i++) {
                var fireball:Fireball = level.fireballs.get(i) as Fireball;
                for (var j:int = 0; j < level.spiderList.length; j++) {
                    var spider:Spider = level.spiderList[j] as Spider;
                    if(spider != null){
                        if (fireball.hitTestObject(spider)) {
                            level.fireballs.remove(fireball);
                            level.removeChild(spider);
                            level.spiderList[j] = null;
                            
                            //XXX
                            //level.harmfulObjects.splice(level.harmfulObjects.indexOf(spider),1);
                            var die = new Embedded.SpiderDieSWF();
                            die.x = spider.x;
                            die.y = spider.y-20;
                            die.scaleX = spider.scaleX;
                            die.scaleY = spider.scaleY;
                            level.addChild(die);
                            level.briefClips.push(die);
                            break;
                        }
                    }
                }
            }
            
			
			
            
            //Brief Clips
            level.briefClips.filter(function(o:Object):Boolean {
               var mc:MovieClip = o as MovieClip;
               return mc.currentFrame != mc.totalFrames;
            });
            
            // calculate new positions of islands
			ViewPIsland.updatePhysics(level.islands, level.columns, new Vector2(0, 9), Constants.DT);
            
            // Make sprites islands match physics islands
			for (var i:int = 0; i < level.islandViews.length; i++) {
				level.islandViews[i].onUpdate();
			}
            
            // update new positions of dynamic objects and update sprite stuff sequentially
			for (var i:int = 0; i < level.rectViews.length; i++) {
				level.rectViews[i].onUpdate(level.islands, Constants.DT, level.rectViews[i].sprite.resolveCollision);
			}
			
			if (level.frameCount % 30 == 0) {
				FireHandler.spreadFire(level, level.frameCount);
			}
			
			// TODO this goes away once we move velocity into game logic 
			for each (var islandView:ViewPIsland in level.islandViews) {
				if (Math.abs(islandView.phys.velocity.y) > 0.01) {
					var tileEntity:TileEntity = islandView.sprite as TileEntity;
					if (level.movingTiles.indexOf(islandView) == -1) {
						//trace("adding to moving tiles");
						for each (var cell:Vector2i in tileEntity.cells) {
							level.tileEntityGrid[cell.y][cell.x] = null;
						}
						level.movingTiles.push(islandView);
						tileEntity.oldGlobalAnchor = new Vector2(tileEntity.globalAnchor.x, tileEntity.globalAnchor.y);
					}
				}
			}
			level.movingTiles = level.movingTiles.filter(function(islandView) {
				if (Math.abs(islandView.phys.velocity.y) < 0.01) {
					//trace("deleting from moving tiles");
					var tileEntity:TileEntity = islandView.sprite as TileEntity;
					var moveX:int = Math.round(islandView.phys.globalAnchor.x - tileEntity.oldGlobalAnchor.x);
					var moveY:int = Math.round(islandView.phys.globalAnchor.y - tileEntity.oldGlobalAnchor.y);
					tileEntity.globalAnchor = islandView.phys.globalAnchor;
					tileEntity.cells = tileEntity.cells.map(function(cell) {
						return new Vector2i(cell.x + moveX, cell.y + moveY);
					});
					for each (var cell:Vector2i in tileEntity.cells) {
						level.tileEntityGrid[cell.y][cell.x] = tileEntity;
					}
				} else {
					return true;
				}
			});
			
			level.x = Math.floor(level.x * Constants.CAMERA_LAG + (1 - Constants.CAMERA_LAG) * (-level.player.x + 400));
			level.y = Math.floor(level.y * Constants.CAMERA_LAG + (1 - Constants.CAMERA_LAG) * ( -level.player.y + 300));
			
			//resolve game over conditions
			//for each (var s:Sprite in level.harmfulObjects) {
				//if (level.player.hitTestObject(s)) {
					//doGameOver();
                    //return;
				//}
			//}
            
            if (level.player.y > stage.stageHeight+500) {
                trace("fell to your doom, bitch");
                doGameOver();
                return;
            }
			
			if (level.player.x > stage.stageWidth) {
				doGameWon();
			}
        }
        
        
        
        function launchSpark():void {
            //var spark:MovieClip = new Embedded.FiresplooshSWF();
            //spark.x = level.player.x + (level.player.direction == Constants.DIR_RIGHT ? 25 : 5);
            //spark.y = level.player.y + 25;
            //level.briefClips.push(spark);
            //level.addChild(spark);
            //level.playerAttackObjects.push(new PlayerAttackObject(null,new Vector2(spark.x, spark.y)));
        }
		
	}
	
}