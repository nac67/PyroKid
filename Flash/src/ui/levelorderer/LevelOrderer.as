package ui.levelorderer 
{
	import flash.automation.KeyboardAutomationAction;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import pyrokid.Embedded;
	import ui.LevelsInfo;
	import ui.playstates.BasePlayState;
	/**
     * ...
     * @author Nick Cheng
     */
    public class LevelOrderer extends MovieClip
    {
        
		private var grid:ShuffleGrid;
		protected var background:Shape;
		
		private var down_key:uint = 0;
		
        public function LevelOrderer() 
        {
			addBackground(0x000000);
			
			var icon:Bitmap = Utils.getLevelIcon(45);
			icon.scaleX = icon.scaleY = .14;
			
			var numOfLevels:int = LevelsInfo.getTotalNumberOfLevels();
			var numOfCols:Number = 7;
			var numOfRows = Math.ceil(numOfLevels / numOfCols);
			var gridItemWidth:int = icon.width ;
			var gridItemHeight:int = icon.height ;
			
            grid = new ShuffleGrid(numOfRows,numOfCols,gridItemHeight,gridItemWidth,1);

			//for (var i : int = 0; i < grid.numCells; i++)
			//{
				//grid.addItem (new ShuffleGridItem(i+1,gridItemWidth,gridItemHeight));
			//}
			for (var i : int = 0; i < grid.numCells; i++)
			{
				grid.addItem (new ShuffleGridItem(i+1,gridItemWidth,gridItemHeight));
			}

			addChild (grid);
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) {
				down_key = e.keyCode;
				addEventListener(Event.ENTER_FRAME, whileKeyDown);
			}
		}
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SHIFT) {
				printLevelList();
			}
			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) {
				removeEventListener(Event.ENTER_FRAME, whileKeyDown);
			}
		}
		
		private function whileKeyDown(e:Event):void {
			if (down_key == Keyboard.UP) {
				grid.y += 5;
				grid.onScreenYOffset += 5;
			}
			if (down_key == Keyboard.DOWN) {
				grid.y -= 5;
				grid.onScreenYOffset -= 5;
			}
			if (down_key == Keyboard.LEFT) {
				grid.x += 5;
				grid.onScreenXOffset += 5;
			}
			if (down_key == Keyboard.RIGHT) {
				grid.x -= 5;
				grid.onScreenXOffset -= 5;
			}
		}
		
		private function printLevelList():void {
			
			var list:String = "[\nnull,\n";
			for (var row:int = 0; row < grid.rows; row++) {
				for (var col:int = 0; col < grid.cols; col++) {
					//trace(new Point(col, row));
					list += grid.getItemAtPosition(row, col).toString()+",\n";
				}
			}
			//for (var i:int = 0; i < grid.numCells; i++) {
				//list += grid.getItemAt(i).toString()+",\n";
			//}
			list += "];";
			trace(list);
		}
		
		protected function addBackground(color:uint, alpha:Number = 1.0):void {
            background = new Shape();
            background.graphics.beginFill(color, alpha);
            background.graphics.drawRect(0, 0, Main.MainStage.stageWidth, Main.MainStage.stageHeight);
            background.graphics.endFill();
            addChild(background);
        }
        
    }

}