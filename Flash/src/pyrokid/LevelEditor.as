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
	import physics.Vector2i;
	import ui.*;
    
    public class LevelEditor extends Sprite {
		
		private var level:Level;
		private var buttons:Array;
		
		private var objectEditor:Sprite;
		private var selectedHighlighter:Sprite;
		private var selectedButton:LevelEditorButton;
		private var noObjectSelectedSprite:Sprite;
		
		private var editMode:int;
		private var numEditModes:int = 3;
		private var typeSelected = 0;
		private var selectedCell:Vector2i;
	        
        public function LevelEditor(level:Level):void {
			this.level = level;
			editMode = 0;
			
			objectEditor = new Sprite();
			selectedHighlighter = new Sprite();
			selectedHighlighter.graphics.lineStyle(2, 0x00FF00);
			selectedHighlighter.graphics.drawRect(0, 0, Constants.CELL, Constants.CELL);
			noObjectSelectedSprite = new ButtonBackground(0xFF0000, 120, 25, "none selected");
			noObjectSelectedSprite.x = 650;
			noObjectSelectedSprite.y = 400;
			selectedButton = new LevelEditorButton(toggleGravity, 120, 25, 650, 400, ["No Gravity", "Gravity"], [LevelEditorButton.upColor, 0xFF0000]);
			objectEditor.addChild(noObjectSelectedSprite);
			
			buttons = [];
			buttons.push(new LevelEditorButton(toggleEditMode, 120, 25, 650, 50, ["Editing Background", "Editing Objects", "Object Properties"], [LevelEditorButton.upColor, 0xFF0000, 0x00FF00]));
			
			buttons.push(new LevelEditorInput("Map Width", level.numCellsWide(), 650, 100, updateWidth));
			buttons.push(new LevelEditorInput("Map Height", level.numCellsTall(), 650, 150, updateHeight));
			
			var options:Dictionary = new Dictionary();
			options[0] = "Empty";
			options[1] = "Dirt Tile";
			options[2] = "Eternal Flame";
			options[3] = "Quick Burn";
			options["spider"] = "Spider";
			options["player"] = "Player";
			buttons.push(new SelectorButton(options, changeSelectedObject));
            trace(noObjectSelectedSprite.x);
            
            toggleEditMode();
		}
		
		private function changeSelectedObject(selected):void {
			typeSelected = selected;
		}
		
		private function toggleGravity():void {
			var cellX:int = selectedCell.x;
			var cellY:int = selectedCell.y;
			level.recipe.walls[cellY][cellX] = -level.recipe.walls[cellY][cellX];
			level.reset(level.recipe);
		}
		
		private function toggleEditMode():void {
			if (editMode == 2) {
				removeChild(objectEditor);
			}
			editMode = (editMode + 1) % numEditModes;
			if (editMode == 2) {
				addChild(objectEditor);
			}
		}
		
		public function turnEditorOn():void {
			Main.MainStage.addEventListener(MouseEvent.CLICK, clickHandler);
			for (var i:int = 0; i < buttons.length; i++) {
				addChild(buttons[i]);
			}
			addChild(objectEditor);
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
			selectedHighlighter.scaleX = level.scaleX;
			selectedHighlighter.scaleY = level.scaleY;
			level.reset(level.recipe);
		}
		
		private function clickHandler(event:MouseEvent):void {
			var cellX:int = event.stageX / (Constants.CELL * level.scaleX);
			var cellY:int = event.stageY / (Constants.CELL * level.scaleY);
			if (cellX >= level.numCellsWide() || cellY >= level.numCellsTall()) {
				return;
			}
			if (editMode == 0) {
				var currentCode:int = level.recipe.walls[cellY][cellX];
				if (currentCode == 0) {
					currentCode = 1;
				} else if (currentCode == 1) {
					currentCode = 0;
				} else {
					return;
				}
				level.recipe.walls[cellY][cellX] = currentCode;
			} else if (editMode == 1) {
				if (typeSelected == "spider") {
					level.recipe.freeEntities.push([cellX, cellY, 0]);
				} else if (typeSelected == "player") {
					level.recipe.playerStart = [cellX, cellY];
				} else {
					level.recipe.freeEntities = level.recipe.freeEntities.filter(function(ent) {
						return ent[0] != cellX || ent[1] != cellY;
					});
					level.recipe.walls[cellY][cellX] = int(typeSelected);
				}
			} else {
				if (level.recipe.walls[cellY][cellX] < -1 || level.recipe.walls[cellY][cellX] > 1) {
					if (noObjectSelectedSprite.parent == objectEditor) {
						objectEditor.removeChild(noObjectSelectedSprite);
						objectEditor.addChild(selectedHighlighter);
						objectEditor.addChild(selectedButton);
					}
					selectedCell = new Vector2i(cellX, cellY);
					selectedButton.reset();
					if (level.recipe.walls[cellY][cellX] < -1) {
						selectedButton.toggle();
					}
					selectedHighlighter.x = cellX * Constants.CELL * level.scaleX;
					selectedHighlighter.y = cellY * Constants.CELL * level.scaleY;
					selectedHighlighter.scaleX = level.scaleX;
					selectedHighlighter.scaleY = level.scaleY;
				}
			}
			level.reset(level.recipe);
		}
		
    }

}