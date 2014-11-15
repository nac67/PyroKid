package pyrokid.entities {
    import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
    import Vector2;
	import Vector2i;
    import pyrokid.*;
	
	public class BurnQuickly extends TileEntity {
		
		public function BurnQuickly(x:int, y:int, objCode:int) {
			super(x, y, objCode);
		}
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var lit:Boolean = super.ignite(level, coor, dir);
            if (lit) {
                for each (var cellSprite:DisplayObject in cellSprites) {
                    addChild(cellSprite);
                }
            }
            return lit;
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (!isOnFire()) {
                return;
            }
            if (currentFrame - ignitionTime == Constants.QUICK_BURN_TIME) {
                for each (var coor:Vector2 in coorsInGlobal()) {
                    addWoodExplode(coor, level);
                }
                for each (var visualCell:Vector2i in visualCells) {
                    addWoodExplode(visualCell.copyAsVec2().AddV(getGlobalAnchor()), level);
                }
                kill(level);
            }
        }
        
        private function addWoodExplode(coor:Vector2, level:Level):void {
            var w:MovieClip = new Embedded.WoodExplodeSWF() as MovieClip;
            var fireClip:BriefClip = new BriefClip(coor.MulD(Constants.CELL), w, velocity.copy().MulD(0.1));
            level.briefClips.push(fireClip);
            level.addChild(fireClip);
        }
		
	}
	
}