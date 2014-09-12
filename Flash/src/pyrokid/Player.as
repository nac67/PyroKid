package pyrokid {
    import flash.display.Sprite;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Player extends Sprite {

        public var speedY:Number = 0;
        
        public function Player() {
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xCCCCFF);
            graphics.drawRect(0, 0, 50, 50);
            graphics.endFill();
            
        }
        
    }

}