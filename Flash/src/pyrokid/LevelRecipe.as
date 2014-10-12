package pyrokid {
    
    public class LevelRecipe {
        
		/* 2D array of integers representing the TileEntities of the map,
		 * where lookup is walls[y][x]. Absolute value of the integer
		 * represents type of entity, and a negative value indicates
		 * that it is affected by gravity. */
        public var walls:Array;
		
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
        
        public static function generateTemplate():LevelRecipe {
            var rec:LevelRecipe = new LevelRecipe();
            rec.walls = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                         [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
                         
            rec.playerStart = [1, 7];
            rec.multiTileObjects = [];
            rec.freeEntities = [];
                         
            return rec;
        }
    
    }
    
}