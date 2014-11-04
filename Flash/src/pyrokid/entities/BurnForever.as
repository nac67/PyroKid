package pyrokid.entities {
    import flash.display.MovieClip;
	import flash.display.Sprite;
	import Vector2i;
	import flash.display.DisplayObject;
	import pyrokid.Constants;
	import pyrokid.Level;
    import pyrokid.Embedded;
	
	public class BurnForever extends TileEntity {
		
		public function BurnForever(x:int, y:int, objCode:int) {
			super(x, y, objCode);
		}
		
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            var mc:MovieClip = new Embedded.OilSWF();
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
	}
	
}