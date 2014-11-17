package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import Vector2;
    import pyrokid.*;
    
    public class Spider extends BackAndForthEnemy {
        
        public function Spider(level:Level, startingHealth:int=1) {
            health = startingHealth;
            var swf:MovieClip;
            if (health == 2) {
                swf = new Embedded.SpiderArmorSWF();
            } else {
                swf = new Embedded.SpiderSWF();
            }
            super(level, swf, 0.8, 50, 50, 6, 17, 43, 32);
        }
        
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var oldHealth:int = health;
            var lit:Boolean = super.ignite(level, coor, dir);
            
            if (oldHealth != health && health == 1) {
                // Shed armor
                var armor:MovieClip = new Embedded.ArmorFlySWF() as MovieClip;
                armor.scaleX = swf.scaleX;
                armor.scaleY = swf.scaleY;
                var bc:BriefClip = new BriefClip(new Vector2(swf.x + x, swf.y + y), armor)
                level.briefClips.push(bc);
                level.addChild(bc);
                
                var oldDirection:int = direction;
                direction = Constants.DIR_RIGHT;
                var scale:Number = swf.scaleX;
                removeChild(swf);
                swf = new Embedded.SpiderSWF();
                swf.scaleX = swf.scaleY = scale;
                addChild(swf);
                direction = oldDirection;
                
                if (GameSettings.soundOn) Embedded.loseArmorSound.play();
            }
            
            if (lit) {
                var die:MovieClip = new Embedded.SpiderDieSWF() as MovieClip;
                die.scaleX = swf.scaleX;
                die.scaleY = swf.scaleY;
                var deathAnimation:BriefClip = new BriefClip(new Vector2(swf.x + x, swf.y + y), die);
                if (GameSettings.soundOn) Embedded.spiderdieSound.play();
                kill(level, deathAnimation);
            }
            return lit;
		}
        
    
    }

}