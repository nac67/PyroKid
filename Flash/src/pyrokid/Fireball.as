package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class Fireball extends ProjectileBall {
        
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
            speed = Constants.FBALL_SPEED;
            //range set externally
        }
        
        ///* Takes in a charge time and figures out how far it will travel */
        //public static function calculateRangeInCells(charge:int):Number {
            //return (Constants.MAX_BALL_RANGE-Constants.MIN_BALL_RANGE) * (Number(charge) / Constants.FIREBALL_CHARGE) + Constants.MIN_BALL_RANGE
        //}
    
    }

}