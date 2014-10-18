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
		private var numEditModes:int = 3;
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
			editMode = 0;
            
            // Universal
            UI_Elements = [];
			UI_Elements.push(new LevelEditorButton(toggleEditMode, 120, 25, 650, 50, ["Editing Objects", "Object Properties", "Clumping Objects"], [LevelEditorButton.upColor, 0xFF0000, 0x00FF00, 0x0000FF]));
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
            allObjectTypesButton.visible = editMode == Constants.EDITOR_OBJECT_MODE;
            
            // Edit mode 1
            objectEditor.visible = editMode == Constants.EDITOR_PROPERTIES_MODE;
            var visible:Boolean = editMode == Constants.EDITOR_PROPERTIES_MODE && selectedCell == null;
            noObjectSelectedSprite.visible = visible;
            selectedHighlighter.visible = visible;
			selectedButton.visible = visible;
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
            if (editMode != Constants.EDITOR_PROPERTIES_MODE){
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
            if (editMode != Constants.EDITOR_PROPERTIES_MODE && dragging){
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
			if (editMode != Constants.EDITOR_PROPERTIES_MODE) {
                if (holdStart != null) {
                    var lowX = (cellX < holdStart.x ? cellX : holdStart.x);
                    var highX = (cellX < holdStart.x ? holdStart.x : cellX);
                    var lowY = (cellY < holdStart.y ? cellY : holdStart.y);
                    var highY = (cellY < holdStart.y ? holdStart.y : cellY);
                    
                    handleRectangle(lowX, highX, lowY, highY);
                }
			} 
            
            // Object properties
            else if (level.recipe.walls[cellY][cellX] < -1 || level.recipe.walls[cellY][cellX] > 1) {
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
            
            renderVisibleObjects();
			level.reset(level.recipe);
		}
        
        private function handleRectangle(lowX:int, highX:int, lowY:int, highY:int):void {
            if (editMode == Constants.EDITOR_OBJECT_MODE) {
                for (var cx:int = lowX; cx <= highX; cx++) {
                    for (var cy:int = lowY; cy <= highY; cy++) {
                        placeObject(cx, cy);
                    }   
                }
            } else if (editMode == Constants.EDITOR_ISLAND_MODE) {
                mergeRectangleTiles(level.recipe.islands, lowX, highX, lowY, highY, function(coor:Vector2i, objCode:int):Boolean {
                    return level.recipe.walls[coor.y][coor.x] != Constants.EMPTY_TILE_CODE;
                });
                mergeRectangleTiles(level.recipe.tileEntities, lowX, highX, lowY, highY, function(coor:Vector2i, objCode:int):Boolean {
                    return level.recipe.walls[coor.y][coor.x] == objCode;
                });
                trace("walls:");
                Utils.print2DArr(level.recipe.walls);
                trace("island (connected) ids:");
                Utils.print2DArr(level.recipe.islands);
                trace("tile entities:");
                Utils.print2DArr(level.recipe.tileEntities);
            }
        }
        
        private function mergeRectangleTiles(grid:Array, lowX:int, highX:int, lowY:int, highY:int, canMergeWith:Function):void {
            var nextId:int = getMaxId(grid) + 1;
            var minValOfNewIds:int = nextId;
            
            for (var cx:int = lowX; cx <= highX; cx++) {
                for (var cy:int = lowY; cy <= highY; cy++) {
                    var objCode:int = level.recipe.walls[cy][cx];
                    if (objCode == Constants.EMPTY_TILE_CODE || grid[cy][cx] >= minValOfNewIds) {
                        continue;
                    }
                    
                    var idsBeingConnected:Dictionary = new Dictionary();
                    
                    var isNeighbor:Function = function(coor:Vector2i):Boolean {
                        var inRectangle:Boolean = coor.x >= lowX && coor.x <= highX && coor.y >= lowY && coor.y <= highY;
                        var alreadyConnected:Boolean = idsBeingConnected[grid[coor.y][coor.x]];
                        return canMergeWith(coor, objCode) && (alreadyConnected || inRectangle);
                    }
                    var processNode:Function = function(coor:Vector2i):Boolean {
                        idsBeingConnected[grid[coor.y][coor.x]] = true;
                        grid[coor.y][coor.x] = nextId;
                        return false;
                    }
                    Utils.BFS(Utils.getWidth(grid), Utils.getHeight(grid), new Vector2i(cx, cy), isNeighbor, processNode);
                    nextId += 1;
                }   
            }
            
            normalizeIds(grid);
        }
        
        private static function normalizeIds(grid:Array):void {
            var newLowId:int = 1;
            var oldIdsToNewIds:Dictionary = new Dictionary();
            oldIdsToNewIds[0] = 0;
            Utils.foreach(grid, function(x:int, y:int, id:int):void {
                if (oldIdsToNewIds[id] == undefined) {
                    oldIdsToNewIds[id] = newLowId;
                    newLowId += 1;
                }
                grid[y][x] = oldIdsToNewIds[id];
            });
        }
        
        private static function getMaxId(array:Array):int {
            var maxId:int = 0;
            Utils.foreach(array, function(x:int, y:int, element:int):void {
                maxId = Math.max(maxId, element);
            });
            return maxId;
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
                level.recipe.islands[cellY][cellX] = getMaxId(level.recipe.islands) + 1;
                level.recipe.tileEntities[cellY][cellX] = getMaxId(level.recipe.tileEntities) + 1;
            }
        }
		
    }

}