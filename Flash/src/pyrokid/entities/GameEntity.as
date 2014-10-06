package pyrokid.entities {
	import flash.display.Sprite;
	import pyrokid.Constants;
	
	/* DO NOT directly instantiate this class. Use one of the subclasses. */
	public class GameEntity extends Sprite {
		
		protected var ignitionTime:int = -1;
		private var _w:int;
		private var _h:int;
		
		public function GameEntity(width:Number = 1, height:Number = 1, color:uint = 0xFF0000) {
			_w = width;
			_h = height;
            graphics.lineStyle(0x000000);
            graphics.beginFill(color);
            graphics.drawRect(0, 0, Constants.CELL * width, Constants.CELL * height);
            graphics.endFill();
        }
		
		public function get w():int {
			return _w;
		}
		
		public function get h():int {
			return _h;
		}
		
		public function isOnFire():Boolean {
			return ignitionTime >= 0;
		}
		
		public function ignite(onFire:Array, ignitionFrame:int):void {
		}
	}
	
}