package pyrokid.entities {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import flash.display.Sprite;
    import pyrokid.*;
    import pyrokid.tools.*
    import physics.*;
    
    public class WaterBat extends BackAndForthEnemy {
        public var batHead:MovieClip;
        private var HEAD_ROT_OFFSET = 225; //not sure what happened here
        private var dirToShoot:int;
        
        
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
                //var die:MovieClip = new Embedded.SpiderDieSWF() as MovieClip;
                //die.x = swf.x + x;
                //die.y = swf.y + y;
                //die.scaleX = swf.scaleX;
                //die.scaleY = swf.scaleY;
                //var briefClip:BriefClip = new BriefClip(new Vector2(swf.x + x, swf.y + y), die);
                //level.addChild(briefClip);
                //level.briefClips.push(briefClip);
            }
        }
        
        public override function update(level:Level):void {
            super.update(level);
            
            var xdis:int = level.player.x - this.x;
            var ydis:int = level.player.y - this.y;
            dirToShoot = Utils.getQuadrant(xdis, ydis);
            var shouldShoot:Boolean = true;
            
            if (dirToShoot == Constants.DIR_UP) {
                this.batHead.rotation = -90 - HEAD_ROT_OFFSET;
            } else if (dirToShoot == Constants.DIR_DOWN) {
                this.batHead.rotation = 90 - HEAD_ROT_OFFSET;
            } else if (dirToShoot != this.direction) {
                shouldShoot = false;
                this.batHead.rotation = 180;
            } else {
                this.batHead.rotation =  - HEAD_ROT_OFFSET;
            }
            
        }
    }

}