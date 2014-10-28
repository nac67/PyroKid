package physics {
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysIsland {
        // The Original Location Of The Island In The Tile Grid
        public var tileOriginalLocation:Vector2i = new Vector2i();

        // The Location Of The Island In World For Relative Calculations
        public var globalAnchor:Vector2 = new Vector2();
        public var velocity:Vector2 = new Vector2();
        public var motion:Vector2 = new Vector2();
        
        // Width And Height Of Island In Tiles
        public var tilesWidth:int;
        public var tilesHeight:int;
        
        // Tiles Of The Island
        public var tileGrid:Array;
        
        /**
         * List Of PhysEdge Objects
         */
        public var edges:Array;
        public var clippedEdges:Array;
        
        public var columnAccumulator:Vector2 = new Vector2();
        
        /**
         * Should This Island Be Hovering
         */
        public var isGrounded:Boolean = false;
        
        public function PhysIsland(w:int, h:int) {
            tilesWidth = w;
            tilesHeight = h;
            
            tileGrid = new Array(tilesHeight);
            for (var i:int; i < tileGrid.length; i++) {
                tileGrid[i] = new Array(tilesWidth);
            }
        }
        
        public function AddTile(x:int, y:int, tile:IPhysTile):void {
            if (tile == null)
                return;
            
            tileGrid[y][x] = tile;
            
            // Add Grounding To The Island
            isGrounded = isGrounded || tile.IsGrounded;
        }
        
        public function RebuildEdges():void {
            edges = CollisionResolver.ConstructEdges(tileGrid);
        }
    }
}