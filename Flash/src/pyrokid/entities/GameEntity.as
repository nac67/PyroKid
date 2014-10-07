package pyrokid.entities {
	import flash.display.Sprite;
	import pyrokid.Constants;
	import pyrokid.Level;
	
	/* DO NOT directly instantiate this class. Use one of the subclasses. */
	public class GameEntity extends Sprite {
		
		public var ignitionTime:int = -1;
		private var _w:int;
		private var _h:int;
		
		public function GameEntity(width:Number = 1, height:Number = 1) {
			_w = width * Constants.CELL;
			_h = height * Constants.CELL;
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
		
		public function ignite(level:Level, onFire:Array, ignitionFrame:int, harmfulObjects:Array):void {
		}
	}
	
}