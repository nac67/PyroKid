package pyrokid {
	import flash.display.Sprite;
	import pyrokid.entities.TileEntity;
	
	public class FireHandler extends Sprite {
		
		private static function getNeighbors(entity:TileEntity, fireGrid:Array):Array {
			var neighbors:Array = [];
			var neiCoors:Array = entity.getNeighborCoordinates(fireGrid);
			for (var i:int = 0; i < neiCoors.length; i++) {
				var x:int = neiCoors[i].x;
				var y:int = neiCoors[i].y;
			    neighbors.push(Utils.index(fireGrid, x, y));
			}
			return Utils.filterNull(neighbors);
		}
		
		// not spread every frame BUT should spread when touches something
		public static function spreadFire(level:Level):void {
			for each (var entity:TileEntity in level.onFire) {
                entity.updateFire(level, level.frameCount);
                if (level.frameCount % Constants.SPREAD_RATE == (entity.ignitionTime - 1) % Constants.SPREAD_RATE) {
                    var neighbors:Array = getNeighbors(entity, level.tileEntityGrid);
                    for (var j:int = 0; j < neighbors.length; j++) {
                        if (!neighbors[j].isOnFire()) {
                            neighbors[j].ignite(level, level.frameCount);
                        }
                    }
                }
			}
		}
		
	}
	
}