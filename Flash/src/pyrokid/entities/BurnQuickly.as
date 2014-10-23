package pyrokid.entities {
    import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
    import physics.Vector2;
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
                    addChild(cellSprite);
                }
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (currentFrame - ignitionTime == Constants.QUICK_BURN_TIME) {
                for each (var coor:Vector2 in coorsInGlobal()) {
                    var w:MovieClip = new Embedded.WoodExplodeSWF() as MovieClip;
                    var fireClip:BriefClip = new BriefClip(coor.MulD(Constants.CELL), w, velocity.copy().MulD(0.1));
                    level.briefClips.push(fireClip);
                    level.addChild(fireClip);
                    kill(level);
                }
            }
        }
		
	}
	
}