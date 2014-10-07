package pyrokid.entities {
    import flash.display.MovieClip;
	import flash.display.Sprite;
	import physics.Vector2i;
	import flash.display.DisplayObject;
	import pyrokid.Constants;
	import pyrokid.Level;
    import pyrokid.Embedded;
	
	public class BurnForever extends TileEntity {
		
		public function BurnForever(x:int, y:int):void {
			super(x, y);
		}
		
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            var mc:MovieClip = new Embedded.OilSWF();
            mc.gotoAndStop(1);
			return mc;
		}
		
		public override function ignite(level:Level, ignitionFrame:int):void {
            for (var i:int = 0; i < cellSprites.length; i++) {
                var mc:MovieClip = cellSprites[i] as MovieClip;
                mc.gotoAndStop(2);
            }
            
			ignitionTime = ignitionFrame;
			level.onFire.push(this);
		}
		
	}
	
}