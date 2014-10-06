package pyrokid {
	import flash.display.Sprite;
	import physics.GameEntity;
	
	public class FireHandler extends Sprite {
		
		private static function getNeighbors(entity:MultiTileGameEntity, fireGrid:Array):Array {
			var neighbors:Array = [];
			var neiCoors:Array = entity.getNeighborCoordinates(fireGrid);
			for (var i:int = 0; i < neiCoors.length; i++) {
				var x:int = neiCoors[i].x;
				var y:int = neiCoors[i].y;
				if (inBounds(fireGrid, x, y)) {
					neighbors.push(fireGrid[y][x]);
				}
			}
			return neighbors.filter(function(obj) {
				return obj != null;
			});
		}
		
		private static function inBounds(array:Array, x:int, y:int):Boolean {
			return y >= 0 && x >= 0 && y < array.length && x < array[0].length;
		}
		
		// not spread every frame BUT should spread when touches something
		public static function spreadFire(onFire:Array, fireGrid:Array, frameCount:int):void {
			var numOnFire:int = onFire.length;
			for (var i:int = 0; i < numOnFire; i++) {
				var neighbors:Array = getNeighbors(onFire[i], fireGrid);
				for (var j:int = 0; j < neighbors.length; j++) {
					if (!neighbors[j].isOnFire()) {
						neighbors[j].ignite(onFire, frameCount);
					}
				}
			}
		}
		
	}
	
}