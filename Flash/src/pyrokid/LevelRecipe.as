package pyrokid {
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class LevelRecipe {
        
        public var walls:Array; //2d array where walls[x][y] is how you lookup. 1 is wall 0 is empty
        public var playerStart:Array; //[xtile, ytile]
        public var plainCrates:Array; //[ [x-left,y-top,w,h] ...]
        
        public function LevelRecipe() {
            //TODO: load this from somewhere
             walls = [
                [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                [1, 0, 1, 0, 0, 0, 1, 0, 0, 1],
                [1, 1, 0, 0, 0, 0, 1, 0, 0, 1],
                [1, 0, 0, 0, 1, 1, 1, 0, 0, 1],
                [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
                
            
            playerStart = [2, 2];
            
            plainCrates = [[5,2,1,1],[7,1,3,2]]
        }
        
    
    }

}