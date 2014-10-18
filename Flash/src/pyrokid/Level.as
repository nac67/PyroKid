package pyrokid {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    
    public class Level extends Sprite {
        
        /* Information from level recipe. Doesn't change while playing game. */
        public var walls:Array;
		public var recipe:Object;
        
        /* Physics information. Generated by physics engine. */
		public var islands:Array;
		public var columns:Array;

        /* Items that don't have a physics representation. */
        public var fireballs:RingBuffer;
        public var briefClips:RingBuffer;
		public var background:CaveBackground;
        
        /* View objects that translate information between entities and physics objects. */
		public var islandViews:Array;
		public var rectViews:Array;
        
        /* FreeEntities (not bound to tiles). */
        public var player:Player;
        public var enemies:Array;
		
		/* TileEntities (bound to tiles except when falling). */
		public var tileEntityGrid:Array; // 2D grid, indexed by [y][x]
		public var movingTiles:Array; // invariant: movingTiles and tileEntityGrid are mutually exclusive sets
		public var onFire:Array;
		
        /* Variables for use throughout the playing of a level. */
		public var frameCount:int = 0;
        public var dirty:Boolean = false; // whether dead items need to be cleared this frame
        
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
        
        private function initializeFreeEntity(freeEntity:FreeEntity, startCellX:int, startCellY:int):void {
            freeEntity.x = startCellX * Constants.CELL;
            freeEntity.y = startCellY * Constants.CELL;
            addChild(freeEntity);
            rectViews.push(new ViewPRect(freeEntity, freeEntity.genPhysRect()));
        }

        public function reset(recipe:Object):void {
            Key.reset();
            
            frameCount = 0;
            
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
			
			movingTiles = [];
            
            enemies = [];
			
			var width:int = walls[0].length;
            var physBoxGrid:Array = Utils.newArray(width, walls.length);
            tileEntityGrid = Utils.newArray(width, walls.length);
            
			var objId:int = 2;
            Utils.foreach(walls, function(x:int, y:int, objCode:int):void {
                var falling:Boolean = false;
                if (objCode < 0) {
                    falling = true;
                    objCode = -objCode;
                }
                
                if (objCode == Constants.WALL_TILE_CODE) {
                    physBoxGrid[y][x] = new PhysBox(1);
                } else if (objCode != Constants.EMPTY_TILE_CODE) {
                    physBoxGrid[y][x] = new PhysBox(objId, falling);
                    objId += 1;
                }
            });

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
                var realObjCode:int = Math.abs(objCode);
				if (realObjCode == Constants.OIL_TILE_CODE) {
					tileEntity = new BurnForever(spriteX, spriteY, realObjCode);
				} else if (realObjCode == Constants.WOOD_TILE_CODE) {
					tileEntity = new BurnQuickly(spriteX, spriteY, realObjCode);
				} else {
					tileEntity = new NonFlammableTile(spriteX, spriteY, realObjCode);
				}
				tileEntity.globalAnchor = isle.globalAnchor;
				addChild(tileEntity);
				for (var iy:int = 0; iy < isle.tileGrid.length; iy++) {
					for (var ix:int = 0; ix < isle.tileGrid[0].length; ix++) {
						var tile:IPhysTile = isle.tileGrid[iy][ix];
						if (tile != null && tile is PhysBox) {
							tileEntity.cells.push(new Vector2i(ix, iy));
							tileEntityGrid[iy + cornerCellY][ix + cornerCellX] = tileEntity;
						}
					}
				}
				tileEntity.finalizeCells();
				islandViews.push(new ViewPIsland(tileEntity, isle));
			}
			
			player = new Player(this);
			initializeFreeEntity(player, recipe.playerStart[0], recipe.playerStart[1]);
            
            for (var i:int = 0; i < recipe.freeEntities.length; i++) {
                var enemy:BackAndForthEnemy;
                if (recipe.freeEntities[i][2] == 0) {
                    enemy = new Spider(this);
                } else {
                    enemy = new BurnForeverEnemy(this);
                }
                initializeFreeEntity(enemy, recipe.freeEntities[i][0], recipe.freeEntities[i][1]);
                enemies.push(enemy);
			}
						            
            fireballs = new RingBuffer(5, function(o:Object) {
                var dispObj:Fireball = o as Fireball;
                
                if (dispObj.fizzOut) {
                    var fizz:MovieClip = new Embedded.FireballFizzSWF() as MovieClip;
                    fizz.x = dispObj.x;
                    fizz.y = dispObj.y;
                    fizz.rotation = dispObj.rotation;
                    self.addChild(fizz);
                    self.briefClips.push(fizz);
                } else {
                    var sploosh:MovieClip = new Embedded.FiresplooshSWF() as MovieClip;
                    sploosh.x = dispObj.x;
                    sploosh.y = dispObj.y;
                    self.addChild(sploosh);
                    self.briefClips.push(sploosh);
                }
                
                self.removeChild(dispObj);
            });
            
            briefClips = new RingBuffer(50, function(o:Object) {
                if (o is DisplayObject) {
                    var dispObj = o as DisplayObject;
                    self.removeChild(dispObj);
                }
            });
        }
		
        
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        
        public function fireballUpdate():void {
				
            
            for (var i:int = 0; i < fireballs.size(); i++) {
                var fireball:Fireball = fireballs.get(i) as Fireball;
				fireball.x += fireball.speedX;
                fireball.y += fireball.speedY;
                
                // ignite TileEntities
				var cellX = Utils.realToCell(fireball.x);
				var cellY = Utils.realToCell(fireball.y);
				var entity:TileEntity = Utils.index(tileEntityGrid, cellX, cellY);
				if (entity != null) {
					// remove fireball from list, also delete from stage
					fireballs.markForDeletion(fireball);
				    entity.ignite(this, frameCount);
				}
                
                // ignite FreeEntities
                for (var j:int = 0; j < enemies.length; j++) {
                    var spider:BackAndForthEnemy = enemies[j] as BackAndForthEnemy;
                    if(spider != null) {
                        if (fireball.hitTestObject(spider)) {
                            fireballs.markForDeletion(fireball);
                            spider.ignite(this, frameCount);
                            
                            //XXX
                            //level.harmfulObjects.splice(level.harmfulObjects.indexOf(spider),1);
                            break;
                        }
                    }
                }
                
                // fireball expiration
                if (fireball.isDead()) {
                    fireball.fizzOut = true;
                    fireballs.markForDeletion(fireball);
                }
            }
            
			fireballs.deleteAllMarked();			
		}
        
        public function launchFireball(range:Number, direction:int):void {
            var fball:Fireball = new Fireball();
            fball.setRange(range);
            fball.x = player.getCenter().x;
            fball.y = player.getCenter().y;
            fball.setDirection(direction);
            fireballs.push(fball);
            addChild(fball);
			Embedded.fireballSound.play();
        }
        
        public function removeDead():void {
            if (!dirty) {
                return;
            }
            
            rectViews = rectViews.filter(function(view) {
                return !view.sprite.isDead;
            });
            enemies = enemies.filter(function(enemy) {
                if (enemy.isDead) {
                    removeChild(enemy);
                }
                return !enemy.isDead;
            });
            
            islands = [];
            var islandRemoved:Boolean = false;
            islandViews = islandViews.filter(function(view) {
                var alive:Boolean = !view.sprite.isDead;
                if (alive) {
                    islands.push(view.phys);
                } else {
                    removeChild(view.sprite);
                    islandRemoved = true;
                }
                return alive;
            });
            if (islandRemoved) {
                columns = IslandSimulator.ConstructCollisionColumns(islands);
            }
            
            for (var y:int = 0; y < tileEntityGrid.length; y++) {
                for (var x:int = 0; x < tileEntityGrid[0].length; x++) {
                    var entity:TileEntity = tileEntityGrid[y][x];
                    if (entity != null && entity.isDead) {
                        tileEntityGrid[y][x] = null;
                    }
                }
            }
            movingTiles = movingTiles.filter(function(tile) {
                return !tile.sprite.isDead;
            });
            onFire = onFire.filter(function(tile) {
                return !tile.isDead;
            });
        }
    }

}