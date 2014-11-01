package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.Constants;
    import Vector2i;
    import flash.display.DisplayObject;
    import pyrokid.Embedded;
    import pyrokid.Level;
    
    public class Exit extends FreeEntity {
        
        private var _canExit:Boolean = false;
        private var sprite:MovieClip;
        
		public function Exit(level:Level) {
            super(level, 1, 50, 50, 10, 10, 30, 30);
            sprite = new Embedded.BombSWF() as MovieClip;
            //sprite.gotoAndStop(2); // TODO schwat is going on here -- Aaron, Nick
            sprite.stop();
            addChild(sprite);
		}
        
        public function canExit():Boolean {
            return _canExit;
        }
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):void {
            if (!isOnFire()) {
                super.ignite(level);
                sprite.gotoAndStop(57);
                trace("exit ignited");
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (!isOnFire()) {
                return;
            }
            if (currentFrame - ignitionTime == Constants.SPREAD_RATE) {
                _canExit = true;
                _ignitionTime = -1;
                trace("exit here");
            }
        }
        
    }
    
}