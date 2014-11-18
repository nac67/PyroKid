package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.Embedded;
    
    public class BurnForeverEnemy extends BackAndForthEnemy {
        
        public function BurnForeverEnemy(level:Level) {
            var swf:MovieClip = new Embedded.LizardSWF() as MovieClip;
            swf.gotoAndStop(1);
            super(level, swf, 1, 48, 40, 12, 8, 32, 29);
        }
        
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var swfAsMC:MovieClip = swf as MovieClip;
            var lit:Boolean = super.ignite(level, coor, dir);
            if (lit) {
                if (GameSettings.soundOn) Embedded.immuneSound.play();
                swfAsMC.gotoAndStop(2);
            }
            return lit;
		}
        
        public function douse(level:Level):void {
            if (isOnFire()) {
                _ignitionTime = -1;
                var swfAsMC:MovieClip = swf as MovieClip;
                swfAsMC.gotoAndStop(1);
            }
        }
    }
    
}