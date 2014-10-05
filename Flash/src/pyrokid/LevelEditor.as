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
	import ui.*;
    
    public class LevelEditor extends Sprite {
		
		private var level:Level;
		private var backgroundMode:Boolean;
		private var buttons:Array;
        
        public function LevelEditor(level:Level):void {
			this.level = level;
			backgroundMode = true;

			buttons = [];
			buttons.push(new LevelEditorButton(toggleBackgroundMode, 120, 25, 650, 50, "Editing Background", "Editing Objects"));
			
			buttons.push(new LevelEditorInput("Map Width", level.numCellsWide(), 650, 100, updateWidth));
			buttons.push(new LevelEditorInput("Map Height", level.numCellsTall(), 650, 150, updateHeight));
			
			var options:Dictionary = new Dictionary();
			options[1] = "yisssss";
			options[2] = "lester";
			options[20] = "malvo";
			options[4] = "nooooo";
			buttons.push(new SelectorButton(options, changeSelectedObject));
		}
		
		private function changeSelectedObject(selected):void {
			trace("selected has changed to " + String(selected));
		}
		
		private function toggleBackgroundMode():void {
			backgroundMode = !backgroundMode;
		}
		
		public function turnEditorOn():void {
			Main.MainStage.addEventListener(MouseEvent.CLICK, clickHandler);
			for (var i:int = 0; i < buttons.length; i++) {
				addChild(buttons[i]);
			}
			scaleAndResetLevel(level.numCellsWide(), level.numCellsTall());
		}
		
		public function turnEditorOff():void {
			Main.MainStage.removeEventListener(MouseEvent.CLICK, clickHandler);
			Utils.removeAllChildren(this);
		}
		
		public function loadLevel(level:Level):void {
			this.level = level;
			scaleAndResetLevel(level.numCellsWide(), level.numCellsTall());
		}
		
		private function updateHeight(newHeight:int):void {
			// TODO if shrinking in size, delete all crates/items that go beyond the edge
			if (newHeight < 1) {
				trace("cannot set size to less than 1");
				return;
			}
			var walls:Array = level.recipe.walls;
			var width:int = walls[0].length;
			var height:int = walls.length;
			if (newHeight >= height) {
				for (var y = height; y < newHeight; y++) {
					var newRow:Array = [];
					for (var x = 0; x < width; x++) {
						newRow.push(1);
					}
					walls.push(newRow);
				}
			} else {
				walls.splice(newHeight);
			}
			level.recipe.walls = walls;
			scaleAndResetLevel(width, newHeight);
		}
		
		private function updateWidth(newWidth:int):void {
			if (newWidth < 1) {
				trace("cannot set size to less than 1");
				return;
			}
			var walls:Array = level.recipe.walls;
			var width:int = walls[0].length;
			var height:int = walls.length;
			if (newWidth >= width) {
				for (var y = 0; y < height; y++) {
					for (var x = width; x < newWidth; x++) {
						walls[y].push(1);
					}
				}
			} else {
				for (var y = 0; y < height; y++) {
					walls[y].splice(newWidth);
				}
			}
			level.recipe.walls = walls;
			scaleAndResetLevel(newWidth, height);
		}
		
		private function scaleAndResetLevel(numCellsWide:int, numCellsTall:int):void {
			level.scaleX = Math.min(1, 450 / (Constants.CELL * numCellsTall), 600 / (Constants.CELL * numCellsWide));
			level.scaleY = level.scaleX;
			level.reset(level.recipe);
		}
		
		private function clickHandler(event:MouseEvent):void {
			var cellX:int = event.stageX / (Constants.CELL * level.scaleX);
			var cellY:int = event.stageY / (Constants.CELL * level.scaleY);
			if (cellX >= level.numCellsWide() || cellY >= level.numCellsTall()) {
				return;
			}
			if (backgroundMode) {
				var currentCode:int = level.recipe.walls[cellY][cellX];
				if (currentCode == 0) {
					currentCode = 1;
				} else if (currentCode == 1) {
					currentCode = 0;
				} else {
					return;
				}
				level.recipe.walls[cellY][cellX] = currentCode;
			} else {
				trace("not in background mode");
			}
			level.reset(level.recipe);
		}
		
    }

}