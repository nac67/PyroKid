package pyrokid {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
	import physics.*;
	import pyrokid.entities.*;
    
    public class Level extends Sprite {
		
        // Level object instances
        public var walls:Array;
		public var recipe:Object;
		public var islands:Array;
		public var columns:Array;

        public var fireballs:RingBuffer;
        public var briefClips:RingBuffer;
        
        // All current objects that player uses to attack, list of PlayerAttackObject
        // Contains fireballs, and contains sparks for a duration of one frame.
        public var playerAttackObjects:Array;
        
        public var player:Player;
		public var playerRect:PhysRectangle;
        
        //XXX this shouldn't be here
        public var spiderView:ViewPRect;
        
        public var spiderList:Array;

        
		
		public var islandViews:Array;
		public var rectViews:Array;
		
		public var background:CaveBackground;
        
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
		
		private function getObjectCode(island:PhysIsland, cornerCellX:int, cornerCellY:int):int {
			for (var iy:int = 0; iy < island.tileGrid.length; iy++) {
				for (var ix:int = 0; ix < island.tileGrid[0].length; ix++) {
					var partOfIsland:Boolean = island.tileGrid[iy][ix] != null;
					if (partOfIsland) {
						return walls[cornerCellY + iy][cornerCellX + ix];
					}
				}
			}
			return 0;
		}

        public function reset(recipe:Object):void {
            var x:int, y:int, w:int, h:int, self:Level = this;
            
            Utils.removeAllChildren(this);
			
			//recipe.walls[0][3] = 2;
			//recipe.walls[0][6] = 2;
			//recipe.walls[0][7] = 2;
			//recipe.multiTileObjects.push([new Vector2i(7, 0), new Vector2i(6, 0)]);

            background = new CaveBackground(recipe.walls[0].length, recipe.walls.length);
            this.addChild(background);
            
			this.recipe = recipe;
            walls = recipe.walls;
			/*trace("tracing walls");
			for (var i:int = 0; i < walls.length; i++) {
				trace(walls[i]);
			}*/
			onFire = [];
			islandViews = [];
			rectViews = [];
            
            spiderList = [];
            playerAttackObjects = [];
			
			tileEntityGrid = [];
            var physBoxGrid:Array = [];
			var width:int = walls[x].length;
            for (y = 0; y < walls.length; y++) {
                physBoxGrid.push(new Array(width));
				tileEntityGrid.push(new Array(width));
            }
            
			var objId:int = 2;
            for (y = 0; y < walls.length; y++) {
                var row:Array = walls[y];
                for (x = 0; x < row.length; x++) {
					var objCode:int = row[x];
					var falling = false;
					if (objCode < 0) {
						falling = true;
						objCode = -objCode;
					}
					
					if (objCode == 1) {
						physBoxGrid[y][x] = new PhysBox(1);
					} else if (objCode != 0) {
						physBoxGrid[y][x] = new PhysBox(objId, falling);
						objId += 1;
					}
                }
            }

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
				var cornerCellX:int = Math.floor(isle.globalAnchor.x);
				var cornerCellY:int = Math.floor(isle.globalAnchor.y);
				var objCode = getObjectCode(isle, cornerCellX, cornerCellY);
				var spriteX:int = Utils.cellToPixel(Math.floor(isle.globalAnchor.x));
				var spriteY:int = Utils.cellToPixel(Math.floor(isle.globalAnchor.y));
				var tileEntity:TileEntity;
				if (Math.abs(objCode) == 2) {
					tileEntity = new BurnForever(spriteX, spriteY);
				} else if (Math.abs(objCode) == 3) {
					tileEntity = new BurnQuickly(spriteX, spriteY);
				} else {
					tileEntity = new TileEntity(spriteX, spriteY);
				}
				tileEntity.globalAnchor = isle.globalAnchor;
				addChild(tileEntity);
				for (var iy:int = 0; iy < isle.tileGrid.length; iy++) {
					for (var ix:int = 0; ix < isle.tileGrid[0].length; ix++) {
						var tile:IPhysTile = isle.tileGrid[iy][ix];
						if (tile != null && tile is PhysBox) {
							var cellX:int = ix + cornerCellX;
							var cellY:int = iy + cornerCellY;
							tileEntity.cells.push(new Vector2i(cellX, cellY));
							tileEntityGrid[cellY][cellX] = tileEntity;
						}
					}
				}
				tileEntity.finalizeCells();
				islandViews.push(new ViewPIsland(tileEntity, isle));
			}
			
			player = new Player(0.55, 0.86);
			addChild(player);
			playerRect = new PhysRectangle();
			playerRect.halfSize = new Vector2(0.275, 0.43);
			playerRect.center.x = recipe.playerStart[0] + playerRect.halfSize.x;
			playerRect.center.y = recipe.playerStart[1] + playerRect.halfSize.y;
			rectViews.push(new ViewPRect(player, playerRect));
            
            
            var spider:Spider = new Spider(.9, .6);
            spider.x = 150;
            spider.y = 0;
            addChild(spider);
            var spiderRect:PhysRectangle = new PhysRectangle();
            spiderRect.halfSize = new Vector2(.45, .3);
            spiderView = new ViewPRect(spider, spiderRect)
            rectViews.push(spiderView);
            spiderList.push(spider);
						            
            fireballs = new RingBuffer(5, function(o:Object) {
                if (o is DisplayObject) {
                    var dispObj = o as DisplayObject;
                    
                    var sploosh:MovieClip = new Embedded.FiresplooshSWF() as MovieClip;
                    sploosh.x = dispObj.x;
                    sploosh.y = dispObj.y;
                    self.addChild(sploosh);
                    self.briefClips.push(sploosh);
                    
                    self.removeChild(dispObj);
                }
            });
            
            briefClips = new RingBuffer(50, function(o:Object) {
                if (o is DisplayObject) {
                    var dispObj = o as DisplayObject;
                    self.removeChild(dispObj);
                }
            });
        }
        
    }

}