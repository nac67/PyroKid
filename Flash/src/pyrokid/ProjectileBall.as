package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class ProjectileBall extends Sprite {
        
        public var speedX:int;
        public var speedY:int;
        public var fball:MovieClip;
        private var age:int;
        public var range:Number;
        
         
        
        public function ProjectileBall() {
            
            //origin at center of ball
            fball = new Embedded.FireballSWF() as MovieClip;
            addChild(fball);
            age = 0;
            setRange(Constants.MAX_BALL_RANGE);
        }
        
        public function setDirection(dir:int) {
            if (dir == Constants.DIR_LEFT) {
                speedX = -Constants.FBALL_SPEED;
                rotation = 180;
            } else if (dir == Constants.DIR_RIGHT) {
                speedX = Constants.FBALL_SPEED;
                rotation = 0;
            } else if (dir == Constants.DIR_UP) {
                speedY = -Constants.FBALL_SPEED;
                rotation = 270;
            } else if (dir == Constants.DIR_DOWN) {
                speedY = Constants.FBALL_SPEED;
                rotation = 90;
            }
        }
        
        /* set range in number of cells, converts to time till expiration */
        public function setRange(numCells:Number) {
            range = numCells * Constants.CELL / Constants.FBALL_SPEED
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