package ui.levelorderer 
{
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import pyrokid.Embedded;
	import ui.LevelsInfo;
	import ui.playstates.BasePlayState;
	/**
     * ...
     * @author Nick Cheng
     */
    public class LevelOrderer extends BasePlayState
    {
        
		private var grid:ShuffleGrid;
		
        public function LevelOrderer() 
        {
			var icon:Bitmap = Utils.getLevelIcon(45);
			icon.scaleX = icon.scaleY = .1;
			
			var numOfLevels:int = LevelsInfo.getTotalNumberOfLevels();
			var numOfCols:Number = 10;
			var numOfRows = Math.ceil(numOfLevels / numOfCols);
			
            grid = new ShuffleGrid(numOfRows,numOfCols,icon.height,icon.width,1);

			for (var i : int = 0; i < grid.numCells; i++)
			{
				grid.addItem (new ShuffleGridItem(i+1));
			}

			addChild (grid);
			
			addEventListener(KeyboardEvent.KEY_UP, keyboardListener);
        }
		
		private function keyboardListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SHIFT) {
				printLevelList();
			}
		}
		
		private function printLevelList():void {
			var list:String = "[\nnull,\n";
			for (var row:int = 0; row < grid.rows; row++) {
				for (var col:int = 0; col < grid.cols; col++) {
					list += grid.getItemAtPosition(row, col).toString()+",\n";
				}
			}
			//for (var i:int = 0; i < grid.numCells; i++) {
				//list += grid.getItemAt(i).toString()+",\n";
			//}
			list += "];";
			trace(list);
		}
        
    }

}