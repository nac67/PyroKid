package pyrokid {
    import flash.display.Sprite;
    
    /**
     * Player can be any width <= 50
     * @author Nick Cheng
     */
    public class Player extends PhysicsObject {

        public function Player() {
            this.isPlayer = true;
            
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xCCCCFF);
            graphics.drawRect(0, 0, 30, Constants.CELL);
            graphics.endFill();
            
            w = 30;
        
        }
    
    }

}
