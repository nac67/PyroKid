package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    
    public class Waterball extends ProjectileBall {
                
        public function Waterball() {
            
            //origin at center of ball
            graphics.beginFill(0x5555FF);
            graphics.drawCircle(0, 0, 5);
            graphics.endFill();
            
            speed = Constants.WATERBALL_SPEED;
            setRange(Constants.WATERBALL_RANGE);
        }
    
    }

}