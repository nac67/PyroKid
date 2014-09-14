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
        
        /**
         * Set size of crate
         * @param cw [Integer] cells wide to make crate
         * @param ch [Integer] cells tall to make crate
         */
        public function setCellSize(cw:int, ch:int):void {
            this.w = cw * Constants.CELL;
            this.h = ch * Constants.CELL;
        }
    
    }

}