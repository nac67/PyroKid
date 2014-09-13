package pyrokid {
    import flash.display.Sprite;
    
    /**
     * The PhysicsObject is a rectangular object whose (x,y) point is located
     * in its top left corner. Its w and h should be multiples of 50.
     * @author Nick Cheng
     */
    public class PhysicsObject extends Sprite {
        
        public var speedY:Number = 0;
        
        public var w:int = Constants.CELL;
        public var h:int = Constants.CELL;
        
        public function PhysicsObject() {
        }
    
    }

}