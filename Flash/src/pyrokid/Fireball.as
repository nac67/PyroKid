package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class Fireball extends Sprite {
        
        public var _speedX:int;
        public var fball:MovieClip;
        
        public function Fireball() {
            
            //origin at center of ball
            fball = new Embedded.FireballSWF() as MovieClip;
            fball.x = -30;
            fball.y = -10;
            addChild(fball);
        }
        
        public function set speedX (val:int) {
            _speedX = val;
            if(_speedX < 0) scaleX = -1;
        }
        
        public function get speedX ():int {
            return _speedX;
        }
    
    }

}