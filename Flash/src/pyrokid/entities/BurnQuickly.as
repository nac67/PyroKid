package pyrokid.entities {
    import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
	import physics.Vector2i;
    import pyrokid.*;
	
	public class BurnQuickly extends TileEntity {
		
		public function BurnQuickly(x:int, y:int, objCode:int) {
			super(x, y, objCode);
		}
		
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            var mc:MovieClip = new Embedded.WoodSWF();
            mc.gotoAndStop(1);
			return mc;
		}
        
        public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                for each (var cellSprite:DisplayObject in cellSprites) {
                    var mc:MovieClip = cellSprite as MovieClip;
                    mc.gotoAndStop(2);
                }
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (currentFrame - ignitionTime == Constants.QUICK_BURN_TIME) {
                // TODO remove from onfire
                for (var i:int = 0; i < cells.length; i++) {
                    var w = new Embedded.WoodExplodeSWF();
                    w.x = (cells[i].x + globalAnchor.x) * Constants.CELL;
                    w.y = (cells[i].y + globalAnchor.y) * Constants.CELL;
                    trace(cells[i]);
                    trace(globalAnchor);
                    trace("poop");
                    level.briefClips.push(w);
                    level.addChild(w);
                    kill(level);
                }
            }
        }
		
	}
	
}