package pyrokid.entities {
	import flash.display.Sprite;
    import physics.Vector2;
	import pyrokid.Constants;
	import pyrokid.Level;
	
	/* DO NOT directly instantiate this class. Use one of the subclasses. */
	public class GameEntity extends Sprite {
		
		protected var _ignitionTime:int = -1;
		private var _w:int;
		private var _h:int;
        
        public var velocity:Vector2;
		
		public function GameEntity(width:Number = 1, height:Number = 1) {
			_w = width * Constants.CELL;
			_h = height * Constants.CELL;
            velocity = new Vector2();
        }
        
        public function get ignitionTime():int {
            return _ignitionTime;
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
		
		public function ignite(level:Level, ignitionFrame:int):void {
		}
	}
	
}