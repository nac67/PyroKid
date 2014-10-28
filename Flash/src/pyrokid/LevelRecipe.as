package pyrokid {
    import Utils;
    import Cardinal;
    
    public class LevelRecipe {
        
		/* 2D array of integers representing the TileEntities of the map,
		 * where lookup is walls[y][x]. Absolute value of the integer
		 * represents type of entity, and a negative value indicates
		 * that it is affected by gravity. */
        public var walls:Array;
        
        public var islands:Array;
        public var tileEntities:Array;
		
		/* Tile the player starts on. [cellX, cellY]. */
        public var playerStart:Array;
		
		/* All objects that consist of multiple cells. Each object is
		 * an array of Vector2i. Example of two multiTiled objects:
		 * [
		 *     [(0, 4), (0, 5)],
		 *     [(3, 2), (3, 3), (2, 3)]
		 * ] */
		public var multiTileObjects:Array;
		
		/* All FreeEntities in the game. Each object is an array of
		 * [cellX, cellY, objectType, . . . optional properties . . .] */
		public var freeEntities:Array;
        
        /**
         * CameraZone[]
         */
        public var cameraZones:Array;
        
        public static function generateTemplate(cellsWide:int, cellsTall:int):LevelRecipe {
            var rec:LevelRecipe = new LevelRecipe();
            
            rec.islands = Utils.newArray(cellsWide, cellsTall);
            rec.tileEntities = Utils.newArray(cellsWide, cellsTall);
            rec.walls = Utils.newArray(cellsWide, cellsTall);
            var id:int = 1;
            Utils.foreach(rec.walls, function(x:int, y:int, element:int):void {
                var wall:Boolean = y == 0 || x == 0 || y == cellsTall - 1 || x == cellsWide - 1;
                var objCode:int = wall ? 1 : 0;
                rec.walls[y][x] = objCode;
                if (wall) {
                    var connectedBools:Array = new Array(4);
                    connectedBools[Cardinal.PX] = (y == 0 || y == cellsTall - 1) && x != cellsWide - 1;
                    connectedBools[Cardinal.NX] = (y == 0 || y == cellsTall - 1) && x != 0;
                    connectedBools[Cardinal.PY] = (x == 0 || x == cellsWide - 1) && y != cellsTall - 1;
                    connectedBools[Cardinal.NY] = (x == 0 || x == cellsWide - 1) && y != 0;
                    rec.islands[y][x] = Utils.getIntFromBooleans(connectedBools);
                } else {
                    rec.islands[y][x] = 0;
                }
                rec.tileEntities[y][x] = objCode;
            });
                         
            rec.playerStart = [1, cellsTall-2];
            rec.multiTileObjects = [];
            rec.freeEntities = [];
                         
            return rec;
        }
        
        // assumes walls is there, but checks everything else
        public static function complete(recipe:Object):void {
            if (recipe.multiTileObjects == null) {
                recipe.multiTileObjects = [];
            }
            if (recipe.freeEntities == null) {
                recipe.freeEntities = [];
            }
            if (recipe.playerStart == null) {
                recipe.playerStart = [1, Utils.getH(recipe.walls) - 2];
            }
            if (recipe.islands == null) {
                recipe.islands = Utils.newArrayOfSize(recipe.walls);
            }
            if (recipe.tileEntities == null) {
                recipe.tileEntities = Utils.newArrayOfSize(recipe.walls);
            }
        }
    
    }
    
}