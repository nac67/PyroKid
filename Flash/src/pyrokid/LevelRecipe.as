package pyrokid {
    import pyrokid.tools.Utils;
    
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
        
        public static function generateTemplate(cellsWide:int, cellsTall:int):LevelRecipe {
            var rec:LevelRecipe = new LevelRecipe();
            
            rec.islands = Utils.newArray(cellsWide, cellsTall);
            rec.tileEntities = Utils.newArray(cellsWide, cellsTall);
            rec.walls = Utils.newArray(cellsWide, cellsTall);
            Utils.foreach(rec.walls, function(x:int, y:int, element:int):void {
                var wall:Boolean = y == 0 || x == 0 || y == cellsTall - 1 || x == cellsWide - 1;
                var objCode:int = wall ? 1 : 0;
                rec.walls[y][x] = objCode;
                rec.islands[y][x] = objCode;
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
                recipe.playerStart = [1, Utils.getHeight(recipe.walls) - 2];
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