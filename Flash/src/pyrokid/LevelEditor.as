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
			
			addChild(new LevelEditorInput("Map Width", level.walls.length, 600, 300, updateWidth));
			addChild(new LevelEditorInput("Map Height", level.walls[0].length, 600, 350, updateHeight));
		}
		
		private function buttonify(event:MouseEvent):void {
			trace("poooop");
		}
		
		public function turnEditorOff():void {
			Main.MainStage.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function updateWidth(w:int):void {
			// TODO if shrinking in size, delete all crates/items that go beyond the edge
			if (w < 1) {
				trace("cannot set size to less than 1");
				return;
			}
			var walls:Array = level.recipe.walls;
			var height:int = walls[0].length;
			if (w >= walls.length) {
				for (var x = walls.length; x < w; x++) {
					var newCol:Array = [];
					for (var y = 0; y < height; y++) {
						newCol.push(1);
					}
					walls.push(newCol);
				}
			} else {
				walls.splice(w);
			}
			level.recipe.walls = walls;
			level.reset(level.recipe);
		}
		
		private function updateHeight(h:int):void {
			if (h < 1) {
				trace("cannot set size to less than 1");
				return;
			}
			var walls:Array = level.recipe.walls;
			var height:int = walls[0].length;
			if (h >= walls[0].length) {
				for (var x = 0; x < walls.length; x++) {
					for (var y = height; y < h; y++) {
						walls[x].push(1);
					}
				}
			} else {
				for (var x = 0; x < walls.length; x++) {
					walls[x].splice(h);
				}
			}
			level.recipe.walls = walls;
			level.reset(level.recipe);
		}
		
		private function clickHandler(event:MouseEvent):void {
			var cellX:int = event.stageX / Constants.CELL;
			var cellY:int = event.stageY / Constants.CELL;
			if (cellX >= level.walls.length || cellY >= level.walls[0].length) {
				return;
			}
			level.recipe.walls[cellX][cellY] = (level.recipe.walls[cellX][cellY] + 1) % 2;
			level.reset(level.recipe);
		}
		
    }

}