package pyrokid {
    import flash.display.Sprite;
    
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
		
		// NOTE: this assumes only 1 tile objects for now. Will need to be expaned
		// later on otherwise multiple children will be added for the same object TODO
		private function addStaticObject(objectCode:int, cellX:int, cellY:int):void {
			if (objectCode == 0) {
				return;
			}
			
			var obj:Sprite;
			if (objectCode == 1) { // background dirt
				obj = new GroundTile();
			} else if (objectCode == 2) { // crate
				obj = new Crate();
				crates.push(obj);
			} else if (objectCode == 3) { // player
				player = new Player();
				obj = player;
			}
			
			obj.x = cellX * Constants.CELL;
			obj.y = cellY * Constants.CELL;
			staticObjects[cellX][cellY] = obj;
			addChild(obj);
		}
        
        public function reset(recipe:Object):void {
            var x:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
            crates = [];
            
            staticObjects = [];
            dynamicObjects = [];
            
            staticObjects = [];
            for (x = 0; x < walls.length; x++) {
                staticObjects.push(new Array(walls[x].length));
            }
            
            for (x = 0; x < walls.length; x++) {
                var column:Array = walls[x];
                for (var y:int = 0; y < column.length; y++) {
					addStaticObject(column[y], x, y);
                }
            }
        }
        
    }

}