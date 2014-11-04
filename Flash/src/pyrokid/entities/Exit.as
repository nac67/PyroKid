package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.Constants;
    import Vector2i;
    import flash.display.DisplayObject;
    import pyrokid.Embedded;
    import pyrokid.Level;
    import pyrokid.BriefClip;
    
    public class Exit extends FreeEntity {
        
        private var _canExit:Boolean = false;
        private var bombSwf:Sprite;
        private var holeSwf:Sprite;
        
		public function Exit(level:Level) {
            super(level, 1, 50, 50, 10, 10, 30, 30);
            bombSwf = new Embedded.Bomb1SWF() as Sprite;
            holeSwf = new Embedded.Bomb3SWF() as Sprite;
            holeSwf.visible = false;
            addChild(bombSwf);
            addChild(holeSwf);
		}
        
        public function canExit():Boolean {
            return _canExit;
        }
        
        public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                bombSwf.visible = false;
                holeSwf.visible = true;
                
                var explode:MovieClip = new Embedded.Bomb2SWF() as MovieClip;
                var deathAnimation:BriefClip = new BriefClip(new Vector2(x, y), explode);
                level.briefClips.push(deathAnimation);
                level.addChild(deathAnimation);                
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (!isOnFire()) {
                return;
            }
            if (currentFrame - ignitionTime == Constants.SPREAD_RATE) {
                _canExit = true;
                _ignitionTime = -1;
            }
        }
        
    }
    
}