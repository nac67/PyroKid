package pyrokid {
    import flash.display.Sprite;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class GroundTile extends Sprite {
        
        public function GroundTile() {
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xEEEEEE);
            graphics.drawRect(0, 0, Constants.CELL, Constants.CELL);
            graphics.endFill();
        
        }
    
    }

}