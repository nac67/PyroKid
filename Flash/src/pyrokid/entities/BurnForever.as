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
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var lit:Boolean = super.ignite(level, coor, dir);
            if (lit) {
                for each (var cellSprite:DisplayObject in cellSprites) {
                    var mc:MovieClip = cellSprite as MovieClip;
                    mc.gotoAndStop(2);
                }
            }
            return lit;
		}
	}
	
}