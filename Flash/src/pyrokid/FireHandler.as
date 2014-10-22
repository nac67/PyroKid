package pyrokid {
	import flash.display.Sprite;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
	
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
        
        private static function spreadToNeighbors(level:Level, entity:TileEntity, fireGrid:Array):void {
            var neighbors:Array = getNeighbors(entity, fireGrid);
            for each (var neighbor:TileEntity in neighbors) {
                neighbor.ignite(level, level.frameCount);
            }
        }
		
		public static function spreadFire(level:Level):void {
            // TODO what about spreading to things that are falling? -- Aaron
			for each (var entity:TileEntity in level.onFire) {
                entity.updateFire(level, level.frameCount);
                
                var timeToSpread:Boolean = level.frameCount % Constants.SPREAD_RATE == (entity.ignitionTime - 1) % Constants.SPREAD_RATE;
                if (timeToSpread) {
                    var fireGrid:Array = entity.isMoving() ? entity.parentIsland.tileEntityGrid : level.tileEntityGrid;
                    spreadToNeighbors(level, entity, fireGrid);
                }
			}
		}
		
	}
	
}