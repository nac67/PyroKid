package pyrokid {
	import flash.display.Sprite;
	import physics.GameEntity;
	
	public class FireHandler extends Sprite {
		
		private static function getNeighbors(entity:GameEntity, fireGrid:Array):Array {
			var neighbors:Array = [];
			if (entity.cellY > 0) {
				neighbors.push(fireGrid[entity.cellY - 1][entity.cellX]);
			}
			if (entity.cellY < fireGrid.length - 1) {
				neighbors.push(fireGrid[entity.cellY + 1][entity.cellX]);
			}
			if (entity.cellX > 0) {
				neighbors.push(fireGrid[entity.cellY][entity.cellX - 1]);
			}
			if (entity.cellX < fireGrid[0].length - 1) {
				neighbors.push(fireGrid[entity.cellY][entity.cellX + 1]);
			}
			return neighbors.filter(function(obj) {
				return obj != null;
			});
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