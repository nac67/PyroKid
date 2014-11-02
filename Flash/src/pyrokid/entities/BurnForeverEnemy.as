package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.Embedded;
    
    public class BurnForeverEnemy extends BackAndForthEnemy {
        
        public function BurnForeverEnemy(level:Level) {
            var swf:MovieClip = new Embedded.LizardSWF() as MovieClip;
            swf.gotoAndStop(1);
            super(level, swf, 1, 50, 40, 12, 8, 32, 29);
        }
        
		public override function ignite(level:Level, ignitionFrame:int):void {
            var swfAsMC:MovieClip = swf as MovieClip;
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                swfAsMC.gotoAndStop(2);
            }
		}
    }
    
}