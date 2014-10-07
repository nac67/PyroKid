package pyrokid {
    import flash.display.Sprite;
	import physics.*;
	import pyrokid.entities.*;
    
    public class Level extends Sprite {
		
        // Level object instances
        public var walls:Array;
        public var player:FreeEntity;
		public var playerRect:PhysRectangle;
		public var recipe:Object;
		public var islands:Array;
		public var columns:Array;
		
		public var islandViews:Array;
		public var rectViews:Array;
        
        //2d grid, tile locked objects, non moving
		public var tileEntityGrid:Array;
        
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

        public function reset(recipe:Object):void {
            var x:int, y:int, w:int, h:int;
            
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
			onFire = [];
			islandViews = [];
			rectViews = [];
			
			tileEntityGrid = [];
            var physBoxGrid:Array = [];
			var width:int = walls[x].length;
            for (y = 0; y < walls.length; y++) {
                physBoxGrid.push(new Array(width));
				tileEntityGrid.push(new Array(width));
            }
            
			var objId:int = 1;
            for (y = 0; y < walls.length; y++) {
                var row:Array = walls[y];
                for (x = 0; x < row.length; x++) {
					var objCode:int = row[x];
					
					if (objCode == 1) {
						physBoxGrid[y][x] = new PhysBox(objId);
						objId += 1;
					}
                }
            }
			/*tileEntityGrid[6][5].ignite(onFire, 0);
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
				tileEntityGrid[cells[i].y][cells[i].x] = multiTile;
				multiTile.entities.push(obj);
				addChild(obj);
			}*/
			
			recipe.multiTileObjects = [];

			for (var i:int = 0; i < recipe.multiTileObjects.length; i++) {
				var multiTileObj:Array = recipe.multiTileObjects[i];
				for (var j:int = 0; j < multiTileObj.length; j++) {
					var cell:Vector2i = multiTileObj[j];
					physBoxGrid[cell.y][cell.x].id = objId;
				}
				objId += 1;
			}
			
            islands = IslandSimulator.ConstructIslands(physBoxGrid);
            columns = IslandSimulator.ConstructCollisionColumns(islands);
			for (var i:int = 0; i < islands.length; i++) {
				var isle:PhysIsland = islands[i];
				var tileEntity:TileEntity = new TileEntity(
					Utils.cellToPixel(Math.floor(isle.globalAnchor.x)),
					Utils.cellToPixel(Math.floor(isle.globalAnchor.y))
				);
				addChild(tileEntity);
				for (var iy:int = 0; iy < isle.tileGrid.length; iy++) {
					for (var ix:int = 0; ix < isle.tileGrid[0].length; ix++) {
						var tile:IPhysTile = isle.tileGrid[iy][ix];
						if (tile != null && tile is PhysBox) {
							var cellX:int = ix + Math.floor(isle.globalAnchor.x);
							var cellY:int = iy + Math.floor(isle.globalAnchor.y);
							tileEntity.cells.push(new Vector2i(cellX, cellY));
							tileEntityGrid[cellY][cellX] = tileEntity;
						}
					}
				}
				islandViews.push(new ViewPIsland(tileEntity, isle));
			}
			
			player = new FreeEntity(0.8, 0.9);
			player.x = 250;
			player.y = 0;
			addChild(player);
			playerRect = new PhysRectangle();
			playerRect.halfSize = new Vector2(0.4, 0.45);
			rectViews.push(new ViewPRect(player, playerRect));
        }
        
    }

}