package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.Embedded;
    
    public class BurnForeverEnemy extends BackAndForthEnemy {
        
        public function BurnForeverEnemy(level:Level, width:Number, height:Number) {
            var swf:MovieClip = new Embedded.BurningManSWF() as MovieClip;
            swf.gotoAndStop(1);
            super(level, swf, 1, 60, 25, 25, 5, 35, 22);
        }
        
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                swf.gotoAndStop(2);
            }
		}
    }
    
}