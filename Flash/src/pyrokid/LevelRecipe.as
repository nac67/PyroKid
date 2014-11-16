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
        
        public var edges:Array;
		
		/* Tile the player starts on. [cellX, cellY]. */
        public var playerStart:Array;
		
		/* All FreeEntities in the game. Each object is an array of
		 * [cellX, cellY, objectType, . . . optional properties . . .] */
		public var freeEntities:Array;
        
        public static function generateTemplate(cellsWide:int = 16, cellsTall:int = 12):LevelRecipe {
            var rec:LevelRecipe = new LevelRecipe();
            
            rec.islands = Utils.newArray(cellsWide, cellsTall);
            rec.tileEntities = Utils.newArray(cellsWide, cellsTall);
            rec.walls = Utils.newArray(cellsWide, cellsTall);
            rec.edges = Utils.newArray(cellsWide, cellsTall);
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
                rec.edges[y][x] = 0;
            });
                         
            rec.playerStart = [1, cellsTall-2];
            rec.freeEntities = [];
                         
            return rec;
        }
        
        // assumes walls is there, but checks everything else
        public static function complete(recipe:Object):void {
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
            if (recipe.edges == null) {
                recipe.edges = Utils.newArrayOfSize(recipe.walls);
                Utils.foreach(recipe.edges, function(x:int, y:int, element:int):void {
                    recipe.edges[y][x] = 0;
                });
            }
        }
    
    }
    
}