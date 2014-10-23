package pyrokid {
	import flash.display.Sprite;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
	
	public class FireHandler extends Sprite {
        
        private static function spreadToNeighbors(level:Level, entity:TileEntity):void {
            var fireGrid:Array = entity.isMoving() ? entity.parentIsland.tileEntityGrid : level.tileEntityGrid;
            var neighborCoors:Array = entity.isMoving() ? entity.neighborsInIsland()
                    : entity.neighborsInGlobal().map(function(coor) { return coor.copyAsVec2i(); } );
            for each (var neiCoor:Vector2i in neighborCoors) {
                var neiEntity:TileEntity = Utils.index(fireGrid, neiCoor.x, neiCoor.y);
                if (neiEntity != null) {
                    neiEntity.ignite(level, level.frameCount);
                }
            }
        }
		
		public static function spreadFire(level:Level):void {
            for each (var freeEntity:FreeEntity in level.enemies) {
                freeEntity.updateFire(level, level.frameCount);
            }
            level.player.updateFire(level, level.frameCount);
			for each (var entity:TileEntity in level.onFire) {
                entity.updateFire(level, level.frameCount);
                var timeToSpread:Boolean = level.frameCount % Constants.SPREAD_RATE == (entity.ignitionTime - 1) % Constants.SPREAD_RATE;
                if (timeToSpread) {
                    spreadToNeighbors(level, entity);
                }
			}
		}
		
	}
	
}