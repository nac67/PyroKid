package pyrokid {
    import flash.display.Sprite;
	import physics.IPhysTile;
	import physics.IslandSimulator;
	import physics.PhysBox;
	import physics.DynamicEntity;
	import physics.Vector2i;
	import physics.GameEntity;
    
    public class Level extends Sprite {
		
        // Level object instances
        public var walls:Array;
        public var player:DynamicEntity;
		public var recipe:Object;
		public var islands:Array;
        
        //2d grid, tile locked objects, non moving
        public var staticObjects:Array;
		public var flammables:Array;
        
        //1d list of moving objects, not locked to tile position
        public var dynamicObjects:Array;
		
		public var onFire:Array;
        
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
				player =  new DynamicEntity(0.8, 0.95);
				obj = player;
				addChild(player);
			}
			
			obj.x = cellX * Constants.CELL;
			obj.y = cellY * Constants.CELL;
			if (obj is PhysBox) {
				staticObjects[cellY][cellX] = obj;
				flammables[cellY][cellX] = new MultiTileGameEntity([obj]);
				addChild(obj);
			}
		}
        
        public function reset(recipe:Object):void {
            var x:int, y:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
			onFire = [];

			flammables = [];
            staticObjects = [];
            for (x = 0; x < walls.length; x++) {
                staticObjects.push(new Array(walls[x].length));
				flammables.push(new Array(walls[x].length));
            }
            
            for (y = 0; y < walls.length; y++) {
                var row:Array = walls[y];
                for (x = 0; x < row.length; x++) {
					addStaticObject(row[x], x, y);
                }
            }
			flammables[6][5].ignite(onFire, 0);
			var cells:Array = [];
			cells.push(new Vector2i(1, 0));
			cells.push(new Vector2i(1, 1));
			cells.push(new Vector2i(2, 1));
			cells.push(new Vector2i(3, 1));
			var multiTile:MultiTileGameEntity = new MultiTileGameEntity([]);
			for (var i:int = 0; i < cells.length; i++) {
				var obj:PhysBox = new PhysBox(true, 0xCCCCFF);
				obj.x = cells[i].x * Constants.CELL;
				obj.y = cells[i].y * Constants.CELL;
				staticObjects[cells[i].y][cells[i].x] = obj;
				flammables[cells[i].y][cells[i].x] = multiTile;
				multiTile.entities.push(obj);
				addChild(obj);
			}
			
            islands = IslandSimulator.ConstructIslands(staticObjects);
        }
        
    }

}