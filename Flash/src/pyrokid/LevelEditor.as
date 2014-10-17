package pyrokid {
	import flash.display.FrameLabel;
    import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
	import ui.*;
    
    public class LevelEditor extends Sprite {
		
		private var level:Level;
        private var levelScale:Number;
        public var reloadLevel:Function;
        
        private var editMode:int;
		private var numEditModes:int = 2;
        private var UI_Elements:Array; // All level editor UI elements
        private var cellsWidthInput:LevelEditorInput;
        private var cellsHeightInput:LevelEditorInput;
		
        // Edit mode 0: Placing objects
        private var dragging:Boolean = false;
        private var holdStart:Vector2i;
        private var draggingRect:Sprite;
        private var allObjectTypesButton:SelectorButton;
		
        // Edit mode 1: Object properties
        private var selectedCell:Vector2i;
        private var typeSelected = 0;
		private var objectEditor:Sprite;
		private var selectedHighlighter:Sprite;
		private var selectedButton:LevelEditorButton;
		private var noObjectSelectedSprite:Sprite;
		
        
        public function LevelEditor(level:Level):void {
			this.level = level;
            addChild(level);
			editMode = 0;
            
            // Universal
            UI_Elements = [];
			UI_Elements.push(new LevelEditorButton(toggleEditMode, 120, 25, 650, 50, ["Editing Objects", "Object Properties"], [LevelEditorButton.upColor, 0xFF0000, 0x00FF00]));
			cellsWidthInput = new LevelEditorInput("Map Width", level.numCellsWide(), 650, 100, updateWidth);
			cellsHeightInput = new LevelEditorInput("Map Height", level.numCellsTall(), 650, 150, updateHeight);
            UI_Elements.push(cellsWidthInput, cellsHeightInput);
            UI_Elements.push(new LevelEditorButton(newLevel, 120, 25, 650, 460, ["New Level"], [LevelEditorButton.upColor, LevelEditorButton.overColor, LevelEditorButton.downColor]));
			
            // Edit Mode 0: Placing objects
			var options:Dictionary = new Dictionary();
			options[Constants.EMPTY_TILE_CODE] = "Empty";
			options[Constants.WALL_TILE_CODE] = "Dirt Tile";
			options[Constants.OIL_TILE_CODE] = "Eternal Flame";
			options[Constants.WOOD_TILE_CODE] = "Quick Burn";
            options[Constants.METAL_TILE_CODE] = "Metal";
			options["spider"] = "Spider";
			options["player"] = "Player";
            options["immune"] = "Immune Enemy";
            allObjectTypesButton = new SelectorButton(options, changeSelectedObject);
			UI_Elements.push(allObjectTypesButton);
            draggingRect = new Sprite();
            draggingRect.graphics.lineStyle(0, 0xFF00FF);
            draggingRect.graphics.drawRect(0, 0, Constants.CELL, Constants.CELL);
            UI_Elements.push(draggingRect);
			
            // Edit mode 1: object properties
			objectEditor = new Sprite();
			selectedHighlighter = new Sprite();
			selectedHighlighter.graphics.lineStyle(2, 0x00FF00);
			selectedHighlighter.graphics.drawRect(0, 0, Constants.CELL, Constants.CELL);
			noObjectSelectedSprite = new ButtonBackground(0xFF0000, 120, 25, "none selected");
			noObjectSelectedSprite.x = 650;
			noObjectSelectedSprite.y = 200;
			selectedButton = new LevelEditorButton(toggleGravity, 120, 25, 650, 200, ["No Gravity", "Gravity"], [LevelEditorButton.upColor, 0xFF0000]);
			objectEditor.addChild(noObjectSelectedSprite);
            objectEditor.addChild(selectedHighlighter);
			objectEditor.addChild(selectedButton);
            UI_Elements.push(objectEditor);
			
            renderVisibleObjects();
		}
        
        private function renderVisibleObjects():void {
            cellsWidthInput.changeText(String(level.walls[0].length));
            cellsHeightInput.changeText(String(level.walls.length));
            
            // Edit mode 0
            draggingRect.visible = false;
            allObjectTypesButton.visible = editMode == 0;
            
            // Edit mode 1
            objectEditor.visible = editMode == 1;
            noObjectSelectedSprite.visible = editMode == 1 && selectedCell == null;
            selectedHighlighter.visible = editMode == 1 && selectedCell != null;
			selectedButton.visible = editMode == 1 && selectedCell != null;
        }
		
        public function getRecipe():Object {
            return level.recipe;
        }
        
        // ----------------------UI Callback Functions---------------------
        
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
			editMode = (editMode + 1) % numEditModes;
            selectedCell = null;
            renderVisibleObjects();
		}
        
        private function newLevel(event:MouseEvent):void {
            reloadLevel(LevelRecipe.generateTemplate(15,10));
        }
        
        private function updateHeight(newHeight:int):void {
			// TODO if shrinking in size, delete all crates/items that go beyond the edge -- Aaron
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
            levelScale = Math.min(1, 450 / (Constants.CELL * numCellsTall), 600 / (Constants.CELL * numCellsWide));
			level.scaleX = level.scaleY = levelScale;
            levelScale = levelScale;
			selectedHighlighter.scaleX = levelScale;
			selectedHighlighter.scaleY = levelScale;
			level.reset(level.recipe);
		}
        
        // ----------------------Editor on off---------------------
		
		public function turnEditorOn():void {
            Main.MainStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            Main.MainStage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Main.MainStage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			for (var i:int = 0; i < UI_Elements.length; i++) {
				addChild(UI_Elements[i]);
			}
			scaleAndResetLevel(level.numCellsWide(), level.numCellsTall());
		}
		
		public function turnEditorOff():void {
            Main.MainStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            Main.MainStage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Main.MainStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			Utils.removeAllChildren(this);
		}
		
		public function loadLevel(level:Level):void {
			this.level = level;
			scaleAndResetLevel(level.numCellsWide(), level.numCellsTall());
            renderVisibleObjects();
		}
		
		
		// ----------------------Mouse Listeners---------------------
        
        private function mouseDown(event:MouseEvent):void {
            if (editMode == 0){
                dragging = true;
                var cellX:int = event.stageX / (Constants.CELL * levelScale);
                var cellY:int = event.stageY / (Constants.CELL * levelScale);
                holdStart = new Vector2i(cellX, cellY);
                draggingRect.scaleX = draggingRect.scaleY = levelScale;
                draggingRect.x = cellX * (Constants.CELL * levelScale)
                draggingRect.y = cellY * (Constants.CELL * levelScale)
            }
        }
        
        private function mouseMove(event:MouseEvent):void {
            if(editMode == 0 && dragging){
                var cellX:int = event.stageX / (Constants.CELL * levelScale);
                var cellY:int = event.stageY / (Constants.CELL * levelScale);
                
                var lowX = (cellX < holdStart.x ? cellX : holdStart.x);
                var highX = (cellX < holdStart.x ? holdStart.x : cellX);
                var lowY = (cellY < holdStart.y ? cellY : holdStart.y);
                var highY = (cellY < holdStart.y ? holdStart.y : cellY);
                
                var w = highX - lowX + 1;
                var h = highY - lowY + 1;
                
                draggingRect.x = lowX * Constants.CELL * levelScale;
                draggingRect.y = lowY * Constants.CELL * levelScale;
                draggingRect.width = w * (Constants.CELL * levelScale);
                draggingRect.height = h * (Constants.CELL * levelScale);
                
                draggingRect.visible = w > 1 || h > 1;
            }
        }
		
		private function mouseUp(event:MouseEvent):void {
            dragging = false;
            draggingRect.visible = false;
            
			var cellX:int = event.stageX / (Constants.CELL * levelScale);
			var cellY:int = event.stageY / (Constants.CELL * levelScale);
			if (cellX >= level.numCellsWide() || cellY >= level.numCellsTall()) {
				return;
			}
            
            // Object addition and removal
			if (editMode == 0) {
                if (holdStart != null) {
                    var lowX = (cellX < holdStart.x ? cellX : holdStart.x);
                    var highX = (cellX < holdStart.x ? holdStart.x : cellX);
                    var lowY = (cellY < holdStart.y ? cellY : holdStart.y);
                    var highY = (cellY < holdStart.y ? holdStart.y : cellY);
                    
                    for (var cx:int = lowX; cx <= highX; cx++) {
                        for (var cy:int = lowY; cy <= highY; cy++) {
                            placeObject(cx, cy);
                        }   
                    }
                }
			} 
            
            // Object properties
            else if(editMode == 1) {
				if (level.recipe.walls[cellY][cellX] < -1 || level.recipe.walls[cellY][cellX] > 1) {
                    selectedCell = new Vector2i(cellX, cellY);
					selectedButton.reset();
					if (level.recipe.walls[cellY][cellX] < -1) {
						selectedButton.toggle();
					}
					selectedHighlighter.x = cellX * Constants.CELL * levelScale;
					selectedHighlighter.y = cellY * Constants.CELL * levelScale;
					selectedHighlighter.scaleX = levelScale;
					selectedHighlighter.scaleY = levelScale;
				}
			}
            
            renderVisibleObjects();
			level.reset(level.recipe);
		}
        
        private function placeObject(cellX:int, cellY:int):void {
            //TODO: This doesn't work -- Aaron
            if (typeSelected == "spider") {
                level.recipe.freeEntities.push([cellX, cellY, 0]);
            } else if (typeSelected == "player") {
                level.recipe.playerStart = [cellX, cellY];
            } else if (typeSelected == "immune") {
                level.recipe.freeEntities.push([cellX, cellY, 1]);
            } else {
                level.recipe.freeEntities = level.recipe.freeEntities.filter(function(ent) {
                    return ent[0] != cellX || ent[1] != cellY;
                });
                level.recipe.walls[cellY][cellX] = int(typeSelected);
            }
        }
		
    }

}