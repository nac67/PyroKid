package pyrokid {
    import flash.display.Sprite;
	import pyrokid.entities.TileEntity;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class GroundTile extends TileEntity {
        
        public function GroundTile() {
            this.addChild(new Embedded.DirtBMP());
        
        }
    
    }

}