package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.tools.*
    
    public class WaterBat extends BackAndForthEnemy {
        public var batHead:MovieClip;
        
        public function WaterBat(level:Level) {
            
            var mc:MovieClip = new Embedded.WaterBatSWF() as MovieClip;
            batHead = mc.head;
            
            var swf:Sprite = mc;
            super(level, swf, 1, 45, 35, 8, 9, 26, 19, false);
            batHead.gotoAndStop(1);
        }
        
        public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                kill(level);
                //var die = new Embedded.SpiderDieSWF();
                //die.x = swf.x + x;
                //die.y = swf.y + y;
                //die.scaleX = swf.scaleX;
                //die.scaleY = swf.scaleY;
                //level.addChild(die);
                //level.briefClips.push(die);
            }
        }
        
        public override function update(level:Level):void {
            super.update(level);
            
        }
    
    }

}