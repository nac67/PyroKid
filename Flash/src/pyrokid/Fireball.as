package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class Fireball extends Sprite {
        
        public var speedX:int;
        public var speedY:int;
        public var fball:MovieClip;
        private var age:int;
        public var range:Number;
        
        /* False means play impact animation upon removal
         * True means play fizzing out animation upon removal
         * This is set inside fireballUpdate in Level.as
         * Actual creation of the animations is inside the callback
         * function defined in level reset */
        public var fizzOut:Boolean = false; 
        
        public function Fireball() {
            
            //origin at center of ball
            fball = new Embedded.FireballSWF() as MovieClip;
            addChild(fball);
            age = 0;
            setRange(Constants.MAX_BALL_RANGE);
        }
        
        public function setDirection(dir:int):void {
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
        public function setRange(numCells:Number):void {
            range = numCells * Constants.CELL / Constants.FBALL_SPEED
        }
        
        public function isDead ():Boolean {
            age++;
            if (age > range) {
                return true;
            }
            return false;
        }
        
        /* Takes in a charge time and figures out how far it will travel */
        public static function calculateRangeInCells(charge:int):Number {
            return (Constants.MAX_BALL_RANGE-Constants.MIN_BALL_RANGE) * (Number(charge) / Constants.FIREBALL_CHARGE) + Constants.MIN_BALL_RANGE
        }
    
    }

}