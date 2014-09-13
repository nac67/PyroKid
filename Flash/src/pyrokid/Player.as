package pyrokid {
    import flash.display.Sprite;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Player extends PhysicsObject {
        
        public function Player() {
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xCCCCFF);
            graphics.drawRect(0, 0, 50, 50);
            graphics.endFill();
        
        }
    
    }

}