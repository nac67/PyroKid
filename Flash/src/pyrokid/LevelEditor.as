package pyrokid {
	import flash.display.FrameLabel;
    import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
    
    public class LevelEditor extends Sprite {
		
		private var level:Level;
        
        public function LevelEditor(level:Level):void {
			
			this.level = level;
			Main.MainStage.addEventListener(MouseEvent.CLICK, clickHandler);

			var button:LevelEditorButton = new LevelEditorButton("shwiggity", buttonify, 100, 50, 600, 50);
			addChild(button);
			var button2:LevelEditorButton = new LevelEditorButton("figgity", buttonify, 100, 50, 600, 150);
			addChild(button2);
			
			addChild(new LevelEditorInput("Map Width", level.walls.length, 600, 300, function(w:int):void {
				// TODO not reset, and also use the recipe only instead of the level object
				// TODO if shrinking in size, delete all crates/items that go beyond the edge
				if (w < 1) {
					trace("cannot set size to less than 1");
					return;
				}
				if (w >= level.recipe.walls.length) {
					for (var x = level.recipe.walls.length; x < w; x++) {
						var newCol:Array = [];
						for (var y = 0; y < level.recipe.walls[0].length; y++) {
							newCol.push(1);
						}
						level.recipe.walls.push(newCol);
					}
				} else {
					level.recipe.walls.splice(w);
				}
				level.reset(level.recipe);
			}));
			addChild(new LevelEditorInput("Map Height", level.walls[0].length, 600, 350, function(h:int):void {
				// TODO make height changes work
				trace("width is: " + h);
			}));
		}
		
		private function buttonify(event:MouseEvent):void {
			trace("poooop");
		}
		
		public function turnEditorOff():void {
			Main.MainStage.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void {
			var cellX:int = event.stageX / Constants.CELL;
			var cellY:int = event.stageY / Constants.CELL;
			if (cellX >= level.walls.length || cellY >= level.walls[0].length) {
				return;
			}
			
			trace("stage x, y: " + cellX + ", " + cellY);
			var wallObj = level.getStaticObject(cellX, cellY);
			if (wallObj != null) {
				level.removeChild(wallObj);
				level.setStaticObject(cellX, cellY, null);
			} else {
				var a:GroundTile = new GroundTile();
				a.x = cellX * Constants.CELL;
				a.y = cellY * Constants.CELL;
				level.addChild(a);
				level.setStaticObject(cellX, cellY, a);
			}
			//toggleWall(cellX, cellY);
			level.recipe.walls[cellX][cellY] = (level.recipe.walls[cellX][cellY] + 1) % 2;
		}
		
		public function toggleWall(x:int, y:int):void {
			level.recipe.walls[x][y] = (level.recipe.walls[x][y] + 1) % 2;
			// TODO not reset every time?
			level.reset(level.recipe);
		}
    
    }

}