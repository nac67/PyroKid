package pyrokid.entities {
    import pyrokid.*;
    import physics.*;
    import flash.display.DisplayObject;
    
    public class NonFlammableTile extends TileEntity {
        
        public function NonFlammableTile(x:int, y:int, objCode:int) {
			super(x, y, objCode);
		}
        
        public override function ignite(level:Level, ignitionFrame:int):void {
            return;
		}
        
        protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            if (objectCode == Constants.METAL_TILE_CODE) {
			    return new Embedded.MetalBMP();
            } else {
                return new Embedded.DirtBMP();
            }
		}
        
    }
    
}