package physics {
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysIsland {
        // The Location Of The Island In World For Relative Calculations
        public var globalAnchor:Vector2 = new Vector2();
        public var velocity:Vector2 = new Vector2();
        public var motion:Vector2 = new Vector2();
        
        // Width And Height Of Island In Tiles
        public var tilesWidth:int;
        public var tilesHeight:int;
        
        // Tiles Of The Island
        public var tiles:Array;
        
        /**
         * List Of PhysEdge Objects
         */
        public var edges:Array;
        
        /**
         * Should This Island Be Hovering
         */
        public var isGrounded:Boolean = false;
        
        public function PhysIsland(w:int, h:int) {
            tilesWidth = w;
            tilesHeight = h;
            
            tiles = new Array(tilesHeight);
            for (var i:int; i < tiles.length; i++) {
                tiles[i] = new Array(tilesWidth);
            }
        }
        
        public function AddTile(x:int, y:int, tile:IPhysTile):void {
            if (tile == null)
                return;
            
            tiles[y][x] = tile;
            
            // Add Grounding To The Island
            isGrounded = isGrounded || tile.IsGrounded;
        }
        public function AddFullBlock(x:int, y:int) {
            AddTile(x, y, new PhysBox());
        }
        
        public function RebuildEdges():void {
            edges = CollisionResolver.ConstructEdges(tiles);
        }
    }
}