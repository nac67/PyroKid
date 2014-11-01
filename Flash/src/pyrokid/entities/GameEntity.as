package pyrokid.entities {
	import flash.display.Sprite;
    import pyrokid.BriefClip;
    import Vector2;
    import Vector2i;
	import pyrokid.Constants;
	import pyrokid.Level;
	
	/* DO NOT directly instantiate this class. Use one of the subclasses. */
	public class GameEntity extends Sprite {
		
		protected var _ignitionTime:int = -1;
        private var _isDead:Boolean = false;
        public var velocity:Vector2 = new Vector2();
        
        public function kill(level:Level, deathAnimation:BriefClip = null):void {
            _isDead = true;
            level.dirty = true;
            if (deathAnimation != null) {
                level.briefClips.push(deathAnimation);
                level.addChild(deathAnimation);
            }
        }
        
        public function get ignitionTime():int {
            return _ignitionTime;
        }
        
        public function get isDead():Boolean {
            return _isDead;
        }
		
		public function isOnFire():Boolean {
			return ignitionTime >= 0;
		}
        
        public function isMoving():Boolean {
            return velocity.x + velocity.y != 0;
        }
		
		public function ignite(level:Level, coor:Vector2i = null, dir:int = -1):void {
            if (!isOnFire()) {
                _ignitionTime = level.frameCount;
            }
		}
        
        public function updateFire(level:Level, currentFrame:int):void {
            
        }
        
        /* If entity is on fire, it will light this object on fire, and vice versa. */
        public function mutualIgnite(level:Level, entity:GameEntity):void {
            var thisOnFire:Boolean = isOnFire();
            var entityOnFire:Boolean = entity.isOnFire();
            if (entityOnFire) {
                ignite(level);
            }
            if (thisOnFire) {
                entity.ignite(level);
            }
        }
	}
	
}