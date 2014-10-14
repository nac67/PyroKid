package pyrokid.entities {
	import flash.display.Sprite;
    import physics.Vector2;
    import physics.Vector2i;
	import pyrokid.Constants;
	import pyrokid.Level;
	
	/* DO NOT directly instantiate this class. Use one of the subclasses. */
	public class GameEntity extends Sprite {
		
		protected var _ignitionTime:int = -1;
        private var _isDead:Boolean = false;
		private var _w:int;
		private var _h:int;
        
        public var velocity:Vector2;
		
		public function GameEntity(width:Number, height:Number) {
			_w = width;
			_h = height;
            velocity = new Vector2();
        }
        
        public function kill(level:Level):void {
            _isDead = true;
            level.dirty = true;
        }
        
        public function get ignitionTime():int {
            return _ignitionTime;
        }
        
        public function get isDead():Boolean {
            return _isDead;
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
            if (!isOnFire()) {
                _ignitionTime = ignitionFrame;
            }
		}
        
        /* Returns the center of the object in pixel space W.R.T. the level*/
        public function getCenter():Vector2i {
            return new Vector2i(x + (_w / 2), y + (_h / 2));
        }
        
        /* Returns the center of the object in pixel space W.R.T. this*/
        public function getCenterLocal():Vector2i {
            return new Vector2i((_w / 2), (_h / 2));
        }
        
        /* Sets the center of the object in pixel space */
        public function setCenter(_x:int, _y:int):void {
            this.x = _x - (_w / 2);
            this.y = _y - (_h / 2);
        }
	}
	
}