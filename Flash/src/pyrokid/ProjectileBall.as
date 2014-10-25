package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class ProjectileBall extends Sprite {
        
        public var speedX:int;
        public var speedY:int;
        public var fball:MovieClip;
        private var age:int;
        private var range:Number = 0;
        
        public var speed:Number;
        
        public function ProjectileBall() {
            
            //origin at center of ball
            age = 0;
        }
        
        public function setDirection(dir:int) {
            if (dir == Constants.DIR_LEFT) {
                speedX = -speed;
                rotation = 180;
            } else if (dir == Constants.DIR_RIGHT) {
                speedX = speed;
                rotation = 0;
            } else if (dir == Constants.DIR_UP) {
                speedY = -speed;
                rotation = 270;
            } else if (dir == Constants.DIR_DOWN) {
                speedY = speed;
                rotation = 90;
            }
        }
        
        /* set range in number of cells, converts to time till expiration */
        public function setRange(numCells:Number):void {
            range = numCells * Constants.CELL / speed;
        }
        
        public function isDead ():Boolean {
            age++;
            if (age > range) {
                return true;
            }
            return false;
        }
        
    }

}