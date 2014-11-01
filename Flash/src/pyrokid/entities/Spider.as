package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import Vector2;
    import pyrokid.*;
    
    public class Spider extends BackAndForthEnemy {
        
        public function Spider(level:Level) {
            var swf:MovieClip = new Embedded.SpiderSWF();
            super(level, swf, 0.8, 50, 50, 6, 17, 43, 32);
        }
        
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):void {
            if (!isOnFire()) {
                super.ignite(level);
                var die:MovieClip = new Embedded.SpiderDieSWF() as MovieClip;
                die.scaleX = swf.scaleX;
                die.scaleY = swf.scaleY;
                var deathAnimation:BriefClip = new BriefClip(new Vector2(swf.x + x, swf.y + y), die);
                kill(level, deathAnimation);
            }
		}
        
    
    }

}