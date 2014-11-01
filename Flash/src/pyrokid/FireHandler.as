package pyrokid {
	import flash.display.Sprite;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
	
	public class FireHandler extends Sprite {
		
		public static function spreadFire(level:Level):void {
            for each (var freeEntity:FreeEntity in level.enemies) {
                freeEntity.updateFire(level, level.frameCount);
            }
            level.player.updateFire(level, level.frameCount);
			for each (var entity:TileEntity in level.onFire) {
                entity.updateFire(level, level.frameCount);
                var timeToSpread:Boolean = level.frameCount % Constants.SPREAD_RATE == (entity.ignitionTime - 1) % Constants.SPREAD_RATE;
                if (timeToSpread) {
                    entity.spreadToNeighbors(level);
                }
			}
		}
		
	}
	
}