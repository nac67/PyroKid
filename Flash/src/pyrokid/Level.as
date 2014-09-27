package pyrokid {
    import flash.display.Sprite;
    
	/**
     * ...
     * @author Nick Cheng
     */
    public class Level extends Sprite {
		
		// TODO figure out how to make the recipe an actual LevelRecipe instead
		// of an object. Right now file I/O makes this impossible
		
		
        // Level object instances
        public var walls:Array;
        public var player:Player;
        public var dynamics:Array;
		public var recipe:Object;
        
        public function Level(recipe:Object) {
			trace("recipe is: " + recipe);
			reset(recipe);
        }
        
        public function reset (recipe:Object):void {
            var i:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
            dynamics = [];

            
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
            player.x = recipe.playerStart.x * Constants.CELL;
            player.y = recipe.playerStart.y * Constants.CELL;
            addChild(player);
            
            var c:Crate;
            for (i = 0; i < recipe.plainCrates.length; i++) {
                c = new Crate();
                
                c.x = recipe.plainCrates[i][0] * Constants.CELL;
                c.y = recipe.plainCrates[i][1] * Constants.CELL;
                
                w = recipe.plainCrates[i][2];
                h = recipe.plainCrates[i][3];
                if (w != 1 || h != 1) {
                    c.setCellSize(w, h);
                }
                
                addChild(c);
                dynamics.push(c);
            }
        }
        
    }

}