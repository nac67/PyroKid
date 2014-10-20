package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import physics.PhysBox;
    import physics.PhysRectangle;
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
                var die:Sprite = new Embedded.SpiderDieSWF();
                die.x = swf.x + x;
                die.y = swf.y + y;
                die.scaleX = swf.scaleX;
                die.scaleY = swf.scaleY;
                level.addChild(die);
                level.briefClips.push(die);
            }
		}
        
    
    }

}