package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class Fireball extends Sprite {
        
        public var _speedX:int;
        public var fball:MovieClip;
        private var age:int;
        public var range:Number;
        
        public function Fireball() {
            
            //origin at center of ball
            fball = new Embedded.FireballSWF() as MovieClip;
            fball.x = -30;
            fball.y = -10;
            addChild(fball);
            age = 0;
            setRange(Constants.MAX_BALL_RANGE);
        }
        
        public function set speedX (val:int) {
            _speedX = val;
            if(_speedX < 0) scaleX = -1;
        }
        
        public function get speedX ():int {
            return _speedX;
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
        
        /* Takes in a charge time and figures out how far it will travel */
        public static function calculateRangeInCells(charge:int):Number {
            return (Constants.MAX_BALL_RANGE-Constants.MIN_BALL_RANGE) * (Number(charge) / Constants.FIREBALL_CHARGE) + Constants.MIN_BALL_RANGE
        }
    
    }

}