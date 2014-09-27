package pyrokid {
    import flash.display.Sprite;
    
	/**
     * ...
     * @author Nick Cheng
     */
    public class Level extends Sprite {
        
        // Unchanging level information
        public var walls:Array; //2d array where walls[x][y] is how you lookup. 1 is wall 0 is empty
        public var playerStart:Array; //[xtile, ytile]
        public var plainCrates:Array; //[ [x-left,y-top,w,h] ...]
        
        
        // Level object instances
        public var player:Player;
        public var dynamics:Array = [];
        
        public function Level() {
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
        
        public function reset ():void {
            var i:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
            for (i = 0; i < walls.length; i++) {
                var row:Array = walls[i];
                for (var j:int = 0; j < row.length; j++) {
                    var cell:int = row[j];
                    if (cell == 1) {
                        var a:GroundTile = new GroundTile();
                        a.x = i * Constants.CELL;
                        a.y = j * Constants.CELL;
                        addChild(a);
                    }
                }
            }
            
            player = new Player();
            player.x = playerStart.x * Constants.CELL;
            player.y = playerStart.y * Constants.CELL;
            addChild(player);
            
            var c:Crate;
            for (i = 0; i < plainCrates.length; i++) {
                c = new Crate();
                
                c.x = plainCrates[i][0] * Constants.CELL;
                c.y = plainCrates[i][1] * Constants.CELL;
                
                w = plainCrates[i][2];
                h = plainCrates[i][3];
                if (w != 1 || h != 1) {
                    c.setCellSize(w, h);
                }
                
                addChild(c);
                dynamics.push(c);
            }
        }
        
    }

}