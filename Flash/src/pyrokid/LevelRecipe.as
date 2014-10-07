package pyrokid {
    
    public class LevelRecipe {
        
        public var walls:Array; //2d array where walls[y][x] is how you lookup. 1 is wall 0 is empty
        public var playerStart:Array; //[xtile, ytile]
		public var multiTileObjects:Array;
		public var freeEntities:Array; // [[x0, y0, objCode0], [x1, y1, objCode1], ...]
    
    }

}