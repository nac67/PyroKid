package pyrokid {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
	import physics.IslandSimulator;
	import physics.PhysBox;
	import physics.DynamicEntity;
    
    public class Level extends Sprite {
		
        // Level object instances
        public var walls:Array;
        public var player:Player;
		public var recipe:Object;
		public var islands:Array;
        public var fireballs:RingBuffer; //1d list of active fireballs, TODO, make it a ring buffer with max size
        
        //2d grid, tile locked objects, non moving
        public var staticObjects:Array;
        
        //1d list of moving objects, not locked to tile position
        public var dynamicObjects:Array;
        
        public function Level(recipe:Object):void {
			reset(recipe);
        }
		
		public function numCellsWide():int {
			return walls[0].length;
		}
		
		public function numCellsTall():int {
			return walls.length;
		}
		
		// NOTE: this assumes only 1 tile objects for now. Will need to be expaned
		// later on otherwise multiple children will be added for the same object TODO
		private function addStaticObject(objectCode:int, cellX:int, cellY:int):void {
			if (objectCode == 0) {
				return;
			}
			
			var obj:Sprite;
			if (objectCode == 1) { // background dirt
				obj = new PhysBox();
			} else if (objectCode == 2) { // crate
				return;// obj = new Crate();
			} else if (objectCode == 3) { // player
				player =  new Player(0.8, 0.95);
				obj = player;
			}
			
			obj.x = cellX * Constants.CELL;
			obj.y = cellY * Constants.CELL;
			if (obj != player) {
				staticObjects[cellY][cellX] = obj;
			}
			addChild(obj);
		}
        
        public function reset(recipe:Object):void {
            var x:int, y:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
			
            staticObjects = [];
            for (x = 0; x < walls.length; x++) {
                staticObjects.push(new Array(walls[x].length));
            }
            
            for (y = 0; y < walls.length; y++) {
                var row:Array = walls[y];
                for (x = 0; x < row.length; x++) {
					addStaticObject(row[x], x, y);
                }
            }
			staticObjects[6][5].fire.ignite();
			
            islands = IslandSimulator.ConstructIslands(staticObjects);
            
            fireballs = new RingBuffer(5, function(o:Object) {
                if (o is DisplayObject) {
                    var dispObj = o as DisplayObject;
                    dispObj.parent.removeChild(dispObj);
                }
            });
        }
        
    }

}