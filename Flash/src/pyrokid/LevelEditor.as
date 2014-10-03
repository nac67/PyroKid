package pyrokid {
	import flash.display.FrameLabel;
    import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import Math;
    
    public class LevelEditor extends Sprite {
		
		private var level:Level;
		private var backgroundMode:Boolean;
        
        public function LevelEditor(level:Level):void {
			this.level = level;
			backgroundMode = true;
			Main.MainStage.addEventListener(MouseEvent.CLICK, clickHandler);

			var button:LevelEditorButton = new LevelEditorButton(toggleBackgroundMode, 120, 25, 650, 50, "Editing Background", "Editing Objects");
			addChild(button);
			
			addChild(new LevelEditorInput("Map Width", level.walls.length, 650, 100, updateWidth));
			addChild(new LevelEditorInput("Map Height", level.walls[0].length, 650, 150, updateHeight));
			
			var options:Dictionary = new Dictionary();
			options[1] = "yisssss";
			options[2] = "lester";
			options[20] = "malvo";
			options[4] = "nooooo";
			addChild(new SelectorButton(options, changeSelectedObject));
		}
		
		private function changeSelectedObject(selected):void {
			trace("selected has changed to " + String(selected));
		}
		
		private function toggleBackgroundMode():void {
			backgroundMode = !backgroundMode;
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
			scaleAndResetLevel(w, walls[0].length);
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
			scaleAndResetLevel(walls.length, h);
		}
		
		private function scaleAndResetLevel(numCellsWide:int, numCellsTall:int):void {
			level.scaleX = Math.min(1, 450 / (Constants.CELL * numCellsTall), 600 / (Constants.CELL * numCellsWide));
			level.scaleY = level.scaleX;
			level.reset(level.recipe);
		}
		
		private function clickHandler(event:MouseEvent):void {
			var cellX:int = event.stageX / (Constants.CELL * level.scaleX);
			var cellY:int = event.stageY / (Constants.CELL * level.scaleY);
			if (cellX >= level.walls.length || cellY >= level.walls[0].length) {
				return;
			}
			if (backgroundMode) {
				var currentCode:int = level.recipe.walls[cellX][cellY];
				if (currentCode == 0) {
					currentCode = 1;
				} else if (currentCode == 1) {
					currentCode = 0;
				} else {
					return;
				}
				level.recipe.walls[cellX][cellY] = currentCode;
			} else {
				trace("not in background mode");
			}
			level.reset(level.recipe);
		}
		
    }

}