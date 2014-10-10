package pyrokid {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
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
        //public var playerAttackObjects:Array;
        
        public var player:Player;
		public var playerRect:PhysRectangle;
                
        public var spiderList:Array;
		public var spiderViews:Array;
		
		public var islandViews:Array;
		public var rectViews:Array;
		
		public var background:CaveBackground;
        
        //2d grid, tile locked objects, non moving
		public var tileEntityGrid:Array;
        
        //1d list of moving objects, not locked to tile position
        public var dynamicObjects:Array;
		
		public var onFire:Array;
		
		public var harmfulObjects:Array;
		
		public var movingTiles:Array;
        
		public var frameCount:int = 0;
		
		//SOUNDS
		[Embed(source="../../assets/sound/fireball-sound.mp3")]
		private const fireballSoundClass:Class;
		public var fireballSound:Sound = new fireballSoundClass();
		
        
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
        private function getObjectCodeZ(island:PhysIsland, cornerCellX:int, cornerCellY:int):int {
			for (var iy:int = 0; iy < island.tileGrid.length; iy++) {
				for (var ix:int = 0; ix < island.tileGrid[0].length; ix++) {
					var partOfIsland:Boolean = island.tileGrid[iy][ix] != null;
					if (partOfIsland) {
						return recipe.tiles[cornerCellY + iy][cornerCellX + ix].entityType;
					}
				}
			}
			return 0;
		}

        public function reset(recipe:Object):void {
            
            Key.reset();
            
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
            
            spiderList = [];
            //playerAttackObjects = [];
			harmfulObjects = [];
			
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
			player.x = recipe.playerStart[0] * Constants.CELL;
			player.y = recipe.playerStart[1] * Constants.CELL;
			rectViews.push(new ViewPRect(player, playerRect));
            
			spiderViews = [];
            for (var i:int = 0; i < recipe.freeEntities.length; i++) {
				var spider:Spider = new Spider(.9, .6);
				spider.x = recipe.freeEntities[i][0] * Constants.CELL;
				spider.y = recipe.freeEntities[i][1] * Constants.CELL;
				addChild(spider);
				var spiderRect:PhysRectangle = new PhysRectangle();
				spiderRect.halfSize = new Vector2(.45, .3);
				var spiderView:ViewPRect = new ViewPRect(spider, spiderRect)
				rectViews.push(spiderView);
				spiderList.push(spider);
				spiderViews.push(spiderView);
			}
						            
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
			
			//populate harmful objects list
			for each (var s:Spider in spiderList) {
				harmfulObjects.push(s);
			}
			
        }
		
        public function resetZ(recipe:Object):void {
            var x:int, y:int, w:int, h:int, self:Level = this;
            
            Key.reset();
			onFire = [];
			islandViews = [];
			rectViews = [];
			movingTiles = [];
            spiderList = [];
			spiderViews = [];
            //playerAttackObjects = [];
			harmfulObjects = [];
			
            Utils.removeAllChildren(this);
			
            background = new CaveBackground(recipe.tiles[0].length, recipe.tiles.length);
            this.addChild(background);
            
			this.recipe = recipe;
            walls = recipe.walls;
			tileEntityGrid = [];
            var physBoxGrid:Array = recipe.toPhysTiles();
			
            islands = IslandSimulator.ConstructIslands(physBoxGrid);
            columns = IslandSimulator.ConstructCollisionColumns(islands);
			for (var i:int = 0; i < islands.length; i++) {
				var isle:PhysIsland = islands[i];
				var cornerCellX:int = Math.floor(isle.globalAnchor.x);
				var cornerCellY:int = Math.floor(isle.globalAnchor.y);
				var objCode = getObjectCodeZ(isle, cornerCellX, cornerCellY);
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
			player.x = recipe.playerStart.x * Constants.CELL;
			player.y = recipe.playerStart.y * Constants.CELL;
			rectViews.push(new ViewPRect(player, playerRect));
            
            //for (var i:int = 0; i < recipe.freeEntities.length; i++) {
				//var spider:Spider = new Spider(.9, .6);
				//spider.x = recipe.freeEntities[i][0] * Constants.CELL;
				//spider.y = recipe.freeEntities[i][1] * Constants.CELL;
				//addChild(spider);
				//var spiderRect:PhysRectangle = new PhysRectangle();
				//spiderRect.halfSize = new Vector2(.45, .3);
				//var spiderView:ViewPRect = new ViewPRect(spider, spiderRect)
				//rectViews.push(spiderView);
				//spiderList.push(spider);
				//spiderViews.push(spiderView);
			//}
						            
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
			
			//populate harmful objects list
			for each (var s:Spider in spiderList) {
				harmfulObjects.push(s);
			}
			
        }
		
        
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        
        public function fireballUpdate():void {
			if (Key.isDown(Constants.FIRE_BTN) && !player.prevFrameFireBtn) {
                // Fire button just pressed
                if(player.fireballCooldown == 0){
                    player.fireballCharge = 0;
                    player.isCharging = true;
                    player.fireballCooldown = Constants.FIREBALL_COOLDOWN;
                }
			} else if (Key.isDown(Constants.FIRE_BTN)) {
				// Fire button is being held
                if (player.isCharging && player.fireballCharge < Constants.FIREBALL_CHARGE) {
				    player.fireballCharge++;
                }
			} else if(player.prevFrameFireBtn) {
				// Fire button is released
                if(player.isCharging){
                    player.isCharging = false;
                    player.isShooting = true;
                    
                    if (player.fireballCharge > Constants.FIREBALL_CHARGE) {
                        launchFireball(Constants.MAX_BALL_RANGE);
                    } else {
                        var range = Fireball.calculateRangeInCells(player.fireballCharge);
                        launchFireball(range);
                    }
                }
                player.fireballCharge = 0;
			}
            if (player.fireballCooldown > 0) player.fireballCooldown--;
			player.prevFrameFireBtn = Key.isDown(Constants.FIRE_BTN);
			
            
            for (var i:int = 0; i < fireballs.size(); i++) {
                var fireball:Fireball = fireballs.get(i) as Fireball;
				fireball.x += fireball.speedX;
                
                // ignite TileEntities
				var cellX = CoordinateHelper.realToCell(fireball.x);
				var cellY = CoordinateHelper.realToCell(fireball.y);
				var entity:TileEntity = Utils.index(tileEntityGrid, cellX, cellY);
				if (entity != null) {
					// remove fireball from list, also delete from stage
					fireballs.markForDeletion(fireball);
                    // TODO move isOnFire check inside ignite function.
					if (!entity.isOnFire()) {
						entity.ignite(this, frameCount);
					}
				}
                
                // ignite FreeEntities
                for (var j:int = 0; j < spiderList.length; j++) {
                    var spider:Spider = spiderList[j] as Spider;
                    if(spider != null) {
                        if (fireball.hitTestObject(spider)) {
                            fireballs.markForDeletion(fireball);
                            removeChild(spider);
                            spiderList[j] = null;
                            
                            //XXX
                            //level.harmfulObjects.splice(level.harmfulObjects.indexOf(spider),1);
                            var die = new Embedded.SpiderDieSWF();
                            die.x = spider.x;
                            die.y = spider.y-20;
                            die.scaleX = spider.scaleX;
                            die.scaleY = spider.scaleY;
                            addChild(die);
                            briefClips.push(die);
                            break;
                        }
                    }
                }
                spiderList = Utils.filterNull(spiderList);
                
                // fireball expiration
                if (fireball.isDead()) {
                    fireballs.markForDeletion(fireball);
                }
            }
            
			fireballs.deleteAllMarked();			
		}
        
        function launchFireball(range:Number):void {
            var fball:Fireball = new Fireball();
            fball.setRange(range);
            fball.x = player.x+ (player.direction == Constants.DIR_RIGHT ? 25 : 5);
            fball.y = player.y+25;
            fball.speedX = (player.direction == Constants.DIR_LEFT ? -Constants.FBALL_SPEED : Constants.FBALL_SPEED);
            fireballs.push(fball);
            addChild(fball);
            //playerAttackObjects.push(new PlayerAttackObject(fball));
			fireballSound.play();
        }
        
		
		////// ---------- Deleting tiles ----------------- /////
		
		        /**
         * Destroy A Tile In An Island And Update Level
         * @param island Island Where Destruction Occurs
         * @param tx X Index In Island's Tile Grid
         * @param ty Y Index In Island's Tile Grid
         */
        public function destroyTile(island:PhysIsland, tx:int, ty:int) {
            // Remove Islands
            islands = islands.filter(function (arg) { return arg != island; });
            var oldViews = islandViews;
            islandViews = [];
            for each(var v:ViewPIsland in oldViews) {
                if (v.phys == island) {
					removeChild(v.sprite);
				}
                else islandViews.push(v);
            }

            // Split Island Apart
            if (island.tilesWidth > 1 || island.tilesHeight > 1) {
                island.tileGrid[ty][tx] = null;
                var newIslands:Array = IslandSimulator.ConstructIslands(island.tileGrid);
                for each (var ni:PhysIsland in newIslands) {
                    ni.globalAnchor.AddV(island.globalAnchor);
                    islands.push(ni);
                }
                
                // Rebuild Views
                for (var i:int = 0; i < newIslands.length; i++) {
                    var isle:PhysIsland = newIslands[i];
                    var tileEntity:TileEntity = new TileEntity(
                        Utils.cellToPixel(Math.floor(isle.globalAnchor.x)),
                        Utils.cellToPixel(Math.floor(isle.globalAnchor.y))
                    );
                    tileEntity.globalAnchor = isle.globalAnchor;
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
                    tileEntity.finalizeCells();
                    islandViews.push(new ViewPIsland(tileEntity, isle));
                }
            }
            
            // Rebuild Sets
            columns = IslandSimulator.ConstructCollisionColumns(islands);
        }
        /**
         * Destroy A Tile At A Certain Location And Update Level
         * @param gx Global X Position In Physics World
         * @param gy Global Y Position In Physics World
         */
        public function destroyTilePosition(gx:Number, gy:Number) {
            for each (var island:PhysIsland in islands) {
                var lx:Number = gx - Math.round(island.globalAnchor.x);
                var ilx = int(lx);
                if (ilx < 0 || ilx >= island.tilesWidth) continue;

                var ly:Number = gy - Math.round(island.globalAnchor.y);
                var ily = int(ly);
                if (ily < 0 || ily >= island.tilesHeight) continue;
                
                if (island.tileGrid[ily][ilx] != null) {
                    destroyTile(island, ilx, ily);
                    return;
                }
            }
        }
        
    }

}