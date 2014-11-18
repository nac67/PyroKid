package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.Embedded;
    
    public class Mob extends BackAndForthEnemy {
        
        public function Mob(level:Level) {
            var swf:MovieClip = new Embedded.Mob() as MovieClip;
            swf.gotoAndStop(1);
            super(level, swf, 1, 48, 40, 12, 8, 32, 29);
        }
        
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            return false;
		}
    }
    
}