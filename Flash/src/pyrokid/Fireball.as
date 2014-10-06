package pyrokid {
    import flash.display.Sprite;
    
    public class Fireball extends Sprite {
        
        public var speedX:int;
        
        public function Fireball() {
            
            //origin at center of circle
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xCCCCFF);
            graphics.drawCircle(0, 0, 10);
            graphics.endFill();
        }
    
    }

}