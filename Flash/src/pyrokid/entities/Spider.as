package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import physics.Vector2;
    import pyrokid.*;
    
    public class Spider extends BackAndForthEnemy {
        
        public function Spider(level:Level) {
            var swf:MovieClip = new Embedded.SpiderSWF();
            super(level, swf, 0.8, 50, 50, 6, 17, 43, 32);
        }
        
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                kill(level);
                var die:MovieClip = new Embedded.SpiderDieSWF() as MovieClip;
                die.scaleX = swf.scaleX;
                die.scaleY = swf.scaleY;
                var briefClip:BriefClip = new BriefClip(new Vector2(swf.x + x, swf.y + y), die);
                level.addChild(briefClip);
                level.briefClips.push(briefClip);
            }
		}
        
    
    }

}