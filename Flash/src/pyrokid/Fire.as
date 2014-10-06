package pyrokid {
	import flash.display.Sprite;
	
	public class Fire extends Sprite {
		
		private var ignitionTime:int = -1;
		public var cellX:int;
		public var cellY:int;
		
		public function Fire(cellX:int = 0, cellY:int = 0):void {
			this.cellX = cellX;
			this.cellY = cellY;
		}
		
		private function getNeighbors(fireGrid:Array):Array {
			var neighbors:Array = [];
			if (cellY > 0) {
				neighbors.push(fireGrid[cellY - 1][cellX]);
			}
			if (cellY < fireGrid.length - 1) {
				neighbors.push(fireGrid[cellY + 1][cellX]);
			}
			if (cellX > 0) {
				neighbors.push(fireGrid[cellY][cellX - 1]);
			}
			if (cellX < fireGrid[0].length - 1) {
				neighbors.push(fireGrid[cellY][cellX + 1]);
			}
			return neighbors.filter(function(obj) {
				return obj != null;
			});
		}
		
		public function ignite():void {
			ignitionTime = 0;
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xFF0088);
            graphics.drawRect(20, 20, 10, 10);
            graphics.endFill();
		}
		
		public function isOnFire():Boolean {
			return ignitionTime >= 0;
		}
		
		// not spread every frame BUT should spread when touches something
		public static function spreadFire(onFire:Array, fireGrid:Array):void {
			for (var i:int = 0; i < onFire.length; i++) {
				var neighbors:Array = onFire[i].getNeighbors(fireGrid);
				for (var j:int = 0; j < neighbors.length; j++) {
					neighbors[j].ignite();
				}
			}
		}
		
	}
	
}