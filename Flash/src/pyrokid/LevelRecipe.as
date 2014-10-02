package pyrokid {
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class LevelRecipe {
        
        public var walls:Array; //2d array where walls[x][y] is how you lookup. 1 is wall 0 is empty
        public var playerStart:Array; //[xtile, ytile]
        public var plainCrates:Array; //[ [x-left,y-top,w,h] ...]
        
        public function LevelRecipe(level:int = 0) {
			if (level == 0) {
				//TODO: load this from somewhere
				 walls = [
					[1, 0, 0, 0, 2, 0, 0, 0, 0, 1],
					[1, 0, 2, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 3, 0, 0, 0, 0, 1, 0, 1],
					[1, 0, 1, 0, 0, 2, 0, 0, 0, 1],
					[1, 1, 0, 0, 0, 0, 1, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
					[1, 0, 0, 0, 1, 1, 1, 0, 0, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
					
				
				plainCrates = [[5, 2, 1, 1], [5, 1, 3, 2]];
			} else {
				walls = [
					[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 3, 0, 0, 0, 0, 0, 0, 1],
					[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
					[1, 1, 1, 0, 0, 0, 1, 0, 0, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
					
				
				plainCrates = [];
			}
        }
        
    
    }

}