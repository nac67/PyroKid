package pyrokid {
    import flash.external.ExternalInterface;
    import physics.PhysBox;
    import physics.Vector2i;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ZLevelRecipe {
        public class ZTile { 
            public var entityType:int = 0;
            public var physTileType:int = 0;
            public var isGrounded:Boolean = false;
            
            public function ZTile(et:int = 0, pt:int = 0, g:Boolean = false) {
                entityType = et;
                physTileType = pt;
                isGrounded = g;
            }
        }
        
        public var tiles:Array;
        public var playerStart:Vector2i = new Vector2i(0, 0);
        
        public function ZLevelRecipe(w:int, h:int) {
            tiles = new Array(h);
            for (var y:int = 0; y < h; y++) {
                tiles[y] = new Array(w);
                for (var x:int = 0; x < w; x++) {
                    tiles[y][x] = ZTile();
                }
            }
        }
        
        public function setTile(x:int, y:int, et:int = 0, pt:int = 0, g:Boolean = false) {
            tiles[y][x] = ZTile(et, pt, g);
        }
        
        public function toPhysTiles():Array {
            var pt:Array = new Array(tiles.length);
            var zt:ZTile;
            for (var y:int = 0; y < h; y++) {
                pt[y] = new Array(tiles[x].length);
                for (var x:int = 0; x < w; x++) {
                    zt = tiles[y][x];
                    switch(zt.physTileType) {
                        case 1:
                            pt[y][x] = new PhysBox(zt.physTileType, zt.isGrounded);
                            break;
                        default:
                            pt[y][x] = null;
                            break;
                    }
                }
            }
        }
    }

}