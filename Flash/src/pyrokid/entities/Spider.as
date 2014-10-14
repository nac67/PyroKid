package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import pyrokid.*;
    
    public class Spider extends BackAndForthEnemy {
        
        public function Spider(level:Level, width:Number, height:Number) {
            var swf:MovieClip = new Embedded.SpiderSWF();
            swf.scaleY = .8
            swf.x = 47;
            swf.y = -10;
            super(level, width, height, swf);
        }
        
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                _isDead = true;
                var die = new Embedded.SpiderDieSWF();
                die.x = x;
                die.y = y - 20;
                die.scaleX = scaleX;
                die.scaleY = scaleY;
                level.addChild(die);
                level.briefClips.push(die);
                trace("spider ignited");
            }
		}
        
    
    }

}