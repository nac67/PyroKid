package pyrokid {
    import flash.display.Sprite;
    
	/**
     * ...
     * @author Nick Cheng
     */
    public class Level extends Sprite {		
		
        // Level object instances
        public var walls:Array;
        public var player:Player;
        public var crates:Array;
		public var recipe:Object;
        
        //2d grid, tile locked objects, non moving
        public var staticObjects:Array;
        
        //1d list of moving objects, not locked to tile position
        public var dynamicObjects:Array;
        
        public function Level(recipe:Object):void {
			reset(recipe);
        }
        
        public function setStaticObject(x:int, y:int, obj:Object):void {
            try {
                staticObjects[x][y] = obj;
            } catch (e) {
                throw new Error("Attempted to add an object to the staticObjects matrix but the indices were out of bounds. \n" +
                    "Attempted indices: x: " + x + ", y: " + y + ", actual bounds: x: " + staticObjects.length + ", y: " + staticObjects[0].length);
            }
        }
        
        public function getStaticObject(x:int, y:int):Object {
            try {
                return staticObjects[x][y];
            } catch (e) {
                throw new Error("Attempted to add an object to the staticObjects matrix but the indices were out of bounds. \n" +
                    "Attempted indices: x: " + x + ", y: " + y + ", actual bounds: x: " + staticObjects.length + ", y: " + staticObjects[0].length);
            }
            return null;
        }
        
        public function reset (recipe:Object):void {
            var x:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
            crates = [];
            
            staticObjects = [];
            dynamicObjects = [];
            
            staticObjects = new Array(walls.length);
            for (x = 0; x < walls.length; x++) {
                staticObjects[x] = new Array(walls[x].length);
            }
            
            for (x = 0; x < walls.length; x++) {
                var row:Array = walls[x];
                for (var y:int = 0; y < row.length; y++) {
                    var cell:int = row[y];
                    if (cell == 1) {
                        var a:GroundTile = new GroundTile();
                        a.x = x * Constants.CELL;
                        a.y = y * Constants.CELL;
                        addChild(a);
                        setStaticObject(x, y, a);
                    }
                }
            }
            
            player = new Player();
            player.x = recipe.playerStart[0] * Constants.CELL;
            player.y = recipe.playerStart[1] * Constants.CELL;
            addChild(player);
            
            var c:Crate;
            for (var i = 0; i < recipe.plainCrates.length; i++) {
                c = new Crate();
                
                var xCoor = recipe.plainCrates[i][0];
                var yCoor = recipe.plainCrates[i][1];
                c.x = xCoor * Constants.CELL;
                c.y = yCoor * Constants.CELL;
                
                w = recipe.plainCrates[i][2];
                h = recipe.plainCrates[i][3];
                if (w != 1 || h != 1) {
                    c.setCellSize(w, h);
                }
                
                addChild(c);
                crates.push(c);
                
                for (var cw = 0; cw < w; cw++) {
                    for (var ch = 0; ch < h; ch++) {
                        setStaticObject(xCoor + cw, yCoor + ch, c);
                    }
                }
            }
        }
        
    }

}