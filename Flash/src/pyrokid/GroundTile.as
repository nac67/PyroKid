package pyrokid {
    import flash.display.Sprite;
    import physics.PhysBox;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class GroundTile extends PhysBox {
        
        public function GroundTile() {
            this.addChild(new Embedded.DirtBMP());
        
        }
    
    }

}