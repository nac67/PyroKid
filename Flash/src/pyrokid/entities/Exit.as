package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.Constants;
    import Vector2i;
    import flash.display.DisplayObject;
    import pyrokid.*;
    
    public class Exit extends FreeEntity {
        
        private var _canExit:Boolean = false;
        private var bombSwf:Sprite;
        private var holeSwf:Sprite;
        public var isHole:Boolean;
        
		public function Exit(level:Level, isHole:Boolean = false) {
            super(level, 1, 48, 48, 10, 10, 30, 30);
            bombSwf = new Embedded.Bomb1SWF() as Sprite;
            holeSwf = new Embedded.Bomb3SWF() as Sprite;
            addChild(bombSwf);
            addChild(holeSwf);
            setIsHole(isHole);
            if (isHole) {
                _canExit = true;
            }
		}
        
        private function setIsHole(isHole:Boolean):void {
            this.isHole = isHole;
            bombSwf.visible = !isHole;
            holeSwf.visible = isHole;
        }
        
        public function canExit():Boolean {
            return _canExit;
        }
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            if (isHole || isOnFire()) {
                return false;
            }
            super.ignite(level, coor, dir);
            setIsHole(true);
            
            SoundManager.playSound(Embedded.bombSound);
            
            var explode:MovieClip = new Embedded.Bomb2SWF() as MovieClip;
            var deathAnimation:BriefClip = new BriefClip(new Vector2(x, y), explode);
            level.briefClips.push(deathAnimation);
            level.addChild(deathAnimation);
            return true;
		}
        
        public override function update(level:Level):void {
            if (isBeingSmooshed()) {
                ignite(level);
            }
            if (!isHole) {
                velocity.Add(0, Constants.GRAVITY * Constants.CELL * Constants.DT);
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
        
        public override function projectileCanPassThrough():Boolean {
            return isHole;
        }
        
    }
    
}