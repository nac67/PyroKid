package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.Embedded;
    
    public class Mob extends BackAndForthEnemy {
        
        public function Mob(level:Level) {
            var swf:MovieClip = new Embedded.Mob() as MovieClip;
            swf.gotoAndStop(Math.ceil(Math.random() * 3));
            swf.y = -5;
            swf.x = 20;
            super(level, swf, 1, 48, 40, 12, 8, 32, 29);
            for (var i:int = 0; i < 1; i++) {
                swf = new Embedded.Mob() as MovieClip;
                swf.y = -5;
                swf.scaleX = swf.scaleY = 1 + (Math.random() / 6);
                swf.gotoAndStop(Math.ceil(Math.random() * 3));
                if (i == 0) {
                    swf.x = -20;
                } else {
                    swf.x = 10;
                }
                addChild(swf);
            }
        }
        
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            return false;
		}
    }
    
}