package pyrokid {
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Crate extends PhysicsObject {
        
        public function Crate() {
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xFFEECC);
            graphics.drawRect(0, 0, Constants.CELL, Constants.CELL);
            graphics.endFill();
        }
    
    }

}