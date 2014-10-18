package pyrokid.entities {
    import flash.display.Sprite;
    import pyrokid.*;
    import physics.*;
    import flash.display.DisplayObject;
    
    public class NonFlammableTile extends TileEntity {
        
        public function NonFlammableTile(x:int, y:int, objCode:int, sprite:DisplayObject = null) {
			super(x, y, objCode, sprite);
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