package pyrokid {
    import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.Dictionary;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    import ui.LevelsInfo;

    
    public class Level extends Sprite {
        
        /* Information from level recipe. Doesn't change while playing game. */
        public var walls:Array;
		public var recipe:Object;
        
        /* Physics information. Generated by physics engine. */
		public var islands:Array;
		public var columns:Array;

        /* Items that don't have a physics representation. */
        public var projectiles:RingBuffer;
        public var briefClips:RingBuffer;
        public var delayedFunctions:Dictionary;
		public var background:CaveBackground;
        
        /* View objects that translate information between entities and physics objects. */
		public var islandViews:Array;
		public var rectViews:Array;
        
        /* FreeEntities (not bound to tiles). */
        public var player:Player;
        public var enemies:Array;
        public var smooshedPlayer:BriefClip;
		
		/* TileEntities (bound to tiles except when falling). */
		public var tileEntityGrid:Array; // 2D grid, indexed by [y][x]
		public var movingTiles:Array; // invariant: movingTiles and tileEntityGrid are mutually exclusive sets
		public var onFire:Array;
		
        /* Variables for use throughout the playing of a level. */
		public var frameCount:int;
        public var dirty:Boolean; // whether dead items need to be cleared this frame
        public var gameOverState:int;
        
        public function Level(recipe:Object):void {
			reset(recipe);
        }
		
		public function get cellWidth():int {
			return walls[0].length;
		}
		public function get cellHeight():int {
			return walls.length;
		}

        public function get worldWidth():int {
            return cellWidth * Constants.CELL;
        }
        public function get worldHeight():int {
            return cellHeight * Constants.CELL;
        }
        
        public function reset(recipe:Object):void {
            Main.log.logBeginLevel(LevelsInfo.currLevel);
            LevelRecipe.complete(recipe);
            Key.reset();
            frameCount = 0;
            Utils.removeAllChildren(this);
            
			this.recipe = recipe;
            walls = recipe.walls;
			onFire = [];
			rectViews = [];
			movingTiles = [];
            enemies = [];
            islands = [];
			islandViews = [];
            tileEntityGrid = Utils.newArrayOfSize(walls);
            
		    frameCount = 0;
            dirty = false;
            gameOverState = Constants.GAME_NOT_OVER;
            smooshedPlayer = null;
            
            background = new CaveBackground(Utils.getW(walls), Utils.getH(walls));
            this.addChild(background);
			
            setupTiles();
            setupFreeEntities();
            for each (var enemy:FreeEntity in enemies) {
                if (enemy is Exit) {
                    setChildIndex(enemy, 0); // move exits behind all characters
                }
            }
            setChildIndex(background, 0);
            setupMiscellaneous();
        }
        
        private function setupTiles():void {
            var entityCellMap:Dictionary = Utils.getCellMap(recipe.tileEntities);
            
            // build physTiles grid
            var physTiles:Array = Utils.newArrayOfSize(recipe.walls);
            Utils.foreach(physTiles, function(x:int, y:int, element:TileEntity):void {
                if (recipe.walls[y][x] != Constants.EMPTY_TILE_CODE) {
                    var connectorBools:Array = Utils.getBooleansFromInt(recipe.islands[y][x]);
                    var isFalling:Boolean = Constants.GROUNDED_TYPES.indexOf(recipe.walls[y][x]) == -1;
                    physTiles[y][x] = new PhysBox(connectorBools, isFalling);
                }
            });
            
            // Create physics islands and game islands
            islands = IslandSimulator.ConstructIslands(physTiles);
            columns = IslandSimulator.ConstructCollisionColumns(islands);
            for each (var physIsland:PhysIsland in islands) {
                var gameIsland:Island = new Island(physIsland);
                islandViews.push(new ViewPIsland(gameIsland, physIsland));
            }
            
            var tileEntityList:Array = [];
            // Create tile entities and populate entity grids
            for (var strId:String in entityCellMap) {
                var id:int = int(strId);
                var coors:Array = entityCellMap[id];
                
                // all ids should be the same, so just use the first
                var tileCode:int = recipe.walls[coors[0].y][coors[0].x];
                
                var parentIsland:Island = findParentIsland(coors, islandViews);
                var entity:TileEntity = getEntityFromTileCode(tileCode);
                addChild(entity);
                tileEntityList.push(entity);
                
                // construct entity and setup sprite
                var globalAnchor:Vector2 = Utils.getAnchor(coors);
                entity.cells = coors.map(function(coor) {
                    return coor.copy().SubV(globalAnchor.copyAsVec2i());
                });
                entity.x = globalAnchor.x * Constants.CELL;
                entity.y = globalAnchor.y * Constants.CELL;
                entity.finalizeCells(this, globalAnchor.copyAsVec2i());
                
                parentIsland.addEntity(entity, globalAnchor);
                entity.addEdges(recipe.edges);
                
                for each (var coor:Vector2i in coors) { // relative to global space
                    tileEntityGrid[coor.y][coor.x] = entity;
                }
            }
            
            var connectorGrid:Array = Connector.getActualConnectedGrid(recipe.islands, tileEntityGrid);
            for each (var entity:TileEntity in tileEntityList) {
                entity.addEdges(connectorGrid, true); 
            }
        }
        
        private static function findParentIsland(coors:Array, islandViews:Array):Island {
            return islandViews.filter(function(element) {
                var physIsland:PhysIsland = element.phys;
                var coor:Vector2i = coors[0].copy().SubV(physIsland.globalAnchor.copyAsVec2i());
                return Utils.index(physIsland.tileGrid, coor.x, coor.y) != null;
            })[0].sprite;
        }
        
        private function getEntityFromTileCode(tileCode:int):TileEntity {
            var tileEntity:TileEntity;
            var realObjCode:int = Math.abs(tileCode); // TODO get rid of -- Aaron
            if (realObjCode == Constants.OIL_TILE_CODE) {
                return new BurnForever(0, 0, realObjCode);
            }
            if (realObjCode == Constants.WOOD_TILE_CODE) {
                return new BurnQuickly(0, 0, realObjCode);
            }
            return new NonFlammableTile(0, 0, realObjCode);
        }
        
        private function setupFreeEntities():void {
			player = new Player(this);
			initializeFreeEntity(player, recipe.playerStart[0], recipe.playerStart[1]);
            
            for (var i:int = 0; i < recipe.freeEntities.length; i++) {
                var enemy:FreeEntity;
                if (recipe.freeEntities[i][2] == Constants.SPIDER_CODE) {
                    enemy = new Spider(this, 1);
                } else if (recipe.freeEntities[i][2] == Constants.SPIDER_ARMOR_CODE) {
                    enemy = new Spider(this, 2);
                } else if (recipe.freeEntities[i][2] == Constants.BAT_CODE) {
                    enemy = new WaterBat(this);
                } else if (recipe.freeEntities[i][2] == Constants.BOMB_EXIT_CODE) {
                    enemy = new Exit(this);
                } else if (recipe.freeEntities[i][2] == Constants.HOLE_EXIT_CODE) {
                    enemy = new Exit(this, true);
                } else {
                    enemy = new BurnForeverEnemy(this);
                }
                initializeFreeEntity(enemy, recipe.freeEntities[i][0], recipe.freeEntities[i][1]);
                enemies.push(enemy);
			}
        }
        
        private function initializeFreeEntity(freeEntity:FreeEntity, startCellX:int, startCellY:int):void {
            //put top at top of cell, center object in middle of cell horizontally
            freeEntity.x = (startCellX + .5) * Constants.CELL - (freeEntity.entityWidth / 2);
            freeEntity.y = (startCellY + .5) * Constants.CELL - (freeEntity.entityHeight / 2);
            addChild(freeEntity);
            rectViews.push(new ViewPRect(freeEntity, freeEntity.genPhysRect()));
        }
        
        private function setupMiscellaneous():void {
            var self:Level = this;
            projectiles = new RingBuffer(50, function(o:Object) {
                var dispObj:ProjectileBall = o as ProjectileBall;
                
                var position:Vector2 = new Vector2(dispObj.x, dispObj.y);
                var briefClip:BriefClip;
                var clip:MovieClip;
                var velocity:Vector2 = new Vector2();
                if (dispObj is Fireball) {
                    if (dispObj.fizzOut) {
                        clip = new Embedded.FireballFizzSWF() as MovieClip;
                    } else {
                        clip = new Embedded.FiresplooshSWF() as MovieClip;
                    }
                    briefClip = new BriefClip(position, clip, velocity);
                    briefClip.rotation = dispObj.rotation;
                    self.addChild(briefClip);
                    self.briefClips.push(briefClip);
                }
                
                
                self.removeChild(dispObj);
            });
            
            briefClips = new RingBuffer(50, function(o:Object) {
                if (o is DisplayObject) {
                    var dispObj:DisplayObject = o as DisplayObject;
                    self.removeChild(dispObj);
                    
                    if (o.clip is Player || o.clip is Embedded.PlayerDieFireSWF || o.clip is Embedded.PlayerDiePainSWF) {
                        gameOverState = Constants.GAME_OVER_COMPLETE;
                    }
                }
            });
            
            addTutorialMessage();
            addTutorialImages();
            
            delayedFunctions = new Dictionary();
        }
        
        private function addTutorialImages():void {
            if (LevelsInfo.currLevel == -1) {
                return;
            }
            var houseCoors:Array = LevelsInfo.tutorialHouses[LevelsInfo.currLevel];
            var buildingCoors:Array = LevelsInfo.tutorialBuildings[LevelsInfo.currLevel];
            addImages(houseCoors, "house");
            addImages(buildingCoors, "building");
        }
        
        function getTutorialImage(type:String):Bitmap {
            if (type == "house") {
                var house:Bitmap = new Embedded.HouseBMP() as Bitmap;
                house.y = -50;
                return house;
            }
            if (type == "building") {
                var building:Bitmap = new Embedded.BrickBuildingBMP() as Bitmap;
                building.height = 202;
                return building;
            }
            return null;
        }
        
        private function addImages(coors:Array, type:String):void {
            if (coors != undefined && coors != null) {
                for each (var coor:Vector2i in coors) {
                    var tileEntity:TileEntity = Utils.index(tileEntityGrid, coor.x, coor.y);
                    if (tileEntity != null) {
                        tileEntity.addChild(getTutorialImage(type));
                        if (type == "house") {
                            for (var i:int = 0; i < 3; i++) {
                                tileEntity.addFireLocation(new Vector2i(i, -1));
                                tileEntity.visualCells.push(new Vector2i(i, -1));
                            }
                        }
                    }
                }
            }
        }
		
        private function addTutorialMessage():void {
            if (LevelsInfo.tutorialMessages[LevelsInfo.currLevel] != undefined) {
                var message:String = LevelsInfo.tutorialMessages[LevelsInfo.currLevel];
                
                //TODO: put this in a function, preferably in utils -- Evan, Nick
                var textToAdd:TextField = new TextField();
                textToAdd.width = 800;
                textToAdd.height = 600;
                textToAdd.text = message
                textToAdd.y = 10;
                textToAdd.x = 0
                
                if (format == null) {
                    var format:TextFormat = new TextFormat();
                    format.align = TextFormatAlign.CENTER;
                    format.font = "Arial";
                    format.size = 20;
                    format.color = 0xFFFFFF;
                }
                textToAdd.selectable = false;
                textToAdd.setTextFormat(format);
                
                addChild(textToAdd);
                
            }
        }
        
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        //////////////////////////////////
        
        public function projectileUpdate():void {
            for (var i:int = 0; i < projectiles.size(); i++) {
                var projectile:ProjectileBall = projectiles.get(i) as ProjectileBall;
				projectile.x += projectile.speedX;
                projectile.y += projectile.speedY;
                
                // ignite TileEntities
                // TODO hit falling objects with fireball -- Aaron
                
                var cellX:int = Utils.realToCell(projectile.x);
                var cellY:int = Utils.realToCell(projectile.y);
                var entity:TileEntity = Utils.index(tileEntityGrid, cellX, cellY);
                if (entity != null) {
                    // remove fireball from list, also delete from stage
                    projectiles.markForDeletion(projectile);
                    var dir:int;
                    if (projectile.speedY > 0) {
                        dir = Cardinal.PY;
                    } else if (projectile.speedY < 0) {
                        dir = Cardinal.NY;
                    } else if (projectile.speedX > 0) {
                        dir = Cardinal.PX;
                    } else if (projectile.speedX < 0) {
                        dir = Cardinal.NX;
                    }
                    var coor:Vector2i = new Vector2i(cellX, cellY).SubV(entity.getGlobalAnchorAsVec2i());
                    if (projectile is Fireball) {
                        entity.ignite(this, coor, dir);
                        Main.log.logFireballIgnite(cellX, cellY, Object(entity).constructor);
                    } else if (projectile is Waterball) {
                        if (entity is BurnForever) {
                            var burnForeverEntity:BurnForever = entity as BurnForever;
                            burnForeverEntity.douse(this);
                        }
                    }
                }
                
                // ignite FreeEntities
                if (projectile is Fireball) {
                    for each (var freeEntity:FreeEntity in enemies) {
                        if (freeEntity.isTouching(projectile)) {
                            projectiles.markForDeletion(projectile);
                            freeEntity.ignite(this);
                            Main.log.logFireballIgnite(cellX, cellY, Object(freeEntity).constructor);
                            break;
                        }
                    }
                }
                
                
                if (projectile is Waterball) {
                    if (player.isTouching(projectile)) {
                        projectiles.markForDeletion(projectile);
                        player.damageFromEnemyContact(this);
                    }
                }
                
                // If waterball and fireball collide, remove both
                for (var j:int = 0; j < projectiles.size(); j++) {
                    var otherProj:ProjectileBall = projectiles.get(j) as ProjectileBall;
                    if (projectile is Fireball && otherProj is Waterball) {
                        if (Utils.distance(projectile, otherProj) < 20) {
                            projectiles.markForDeletion(projectile);
                            projectiles.markForDeletion(otherProj);
                        }
                    }
                }
                
                // projectile expiration
                if (projectile.isDead()) {
                    if(projectile is Fireball) {
                        Fireball(projectile).fizzOut = true;
                    }
                    projectiles.markForDeletion(projectile);
                }
            }
            
			projectiles.deleteAllMarked();			
		}
        
        public function launchFireball(range:Number, direction:int):void {
            var fball:Fireball = new Fireball();
            fball.setRange(range);
            fball.x = player.getCenter().x;
            fball.y = player.getCenter().y;
            fball.setDirection(direction);
            projectiles.push(fball);
            addChild(fball);
			if (GameSettings.soundOn) Embedded.fireballSound.play();
        }
        
        public function launchWaterball(x:int, y:int, range:Number, direction:int, additionalVel:Vector2):void {
            var wball:Waterball = new Waterball();
            wball.x = x;
            wball.y = y;
            
            var ballVel:Vector2 = new Vector2(0, 0);
            if (direction == Constants.DIR_LEFT) {
                ballVel.x = -Constants.WATERBALL_SPEED;
            } else if (direction == Constants.DIR_RIGHT) {
                ballVel.x = Constants.WATERBALL_SPEED;
            } else if (direction == Constants.DIR_UP) {
                ballVel.y = -Constants.WATERBALL_SPEED;
            } else if (direction == Constants.DIR_DOWN) {
                ballVel.y = Constants.WATERBALL_SPEED;
            }
            ballVel.AddV(additionalVel);
            wball.setVelocity(ballVel);
            
            projectiles.push(wball);
            addChild(wball);
        }
        
        /* Removes dead items in the level and returns true iff the player died. */
        public function removeDead():void {
            if (!dirty) {
                return;
            }
            var self:Level = this;
            
            rectViews = rectViews.filter(function(view) {
                return !view.sprite.isDead;
            });
            enemies = enemies.filter(function(enemy) {
                if (enemy.isDead) {
                    removeChild(enemy);
                }
                return !enemy.isDead;
            });
            
            var brokenIslandViews:Array = [];
            var oldIslandViews = islandViews;
            islandViews = [];
            islands = [];
            for each (var islandView:ViewPIsland in oldIslandViews) {
                var gameIsland:Island = islandView.sprite;
                var physIsland:PhysIsland = islandView.phys;
                
                var entityRemoved:Boolean = false;
                gameIsland.entityList = gameIsland.entityList.filter(function(entity) {
                    if (entity.isDead) {
                        removeChild(entity);
                        for each (var coor:Vector2i in entity.coorsInIsland()) {
                            gameIsland.tileEntityGrid[coor.y][coor.x] = null;
                            physIsland.tileGrid[coor.y][coor.x] = null;
                        }
                        entityRemoved = true;
                    }
                    return !entity.isDead;
                });
                
                if (entityRemoved) {
                    brokenIslandViews.push(islandView);
                } else {
                    islands.push(physIsland);
                    islandViews.push(islandView);
                }
            }
            
            for each (var brokenIslandView:ViewPIsland in brokenIslandViews) {
                if (brokenIslandView.sprite.entityList.length == 0) {
                    continue;
                }
                
                var brokenPhysIsland:PhysIsland = brokenIslandView.phys;
                var entities:Array = brokenIslandView.sprite.entityList;
                    
                var newIslandViews:Array = [];
                var newIslands:Array = IslandSimulator.ConstructIslands(brokenPhysIsland.tileGrid);
                for each (var newPhysIsland:PhysIsland in newIslands) {
                    newPhysIsland.velocity = brokenPhysIsland.velocity.copy();
                    var newGameIsland:Island = new Island(newPhysIsland);
                    islands.push(newPhysIsland);
                    var newIslandView:ViewPIsland = new ViewPIsland(newGameIsland, newPhysIsland);
                    newIslandViews.push(newIslandView);
                    islandViews.push(newIslandView);
                }
                for each (var entity:TileEntity in entities) {
                    var gameIsland:Island = findParentIsland(entity.coorsInIsland(), newIslandViews);
                    gameIsland.addEntity(entity, entity.islandAnchor.copyAsVec2());
                }
                for each (var newPhysIsland:PhysIsland in newIslands) {
                    newPhysIsland.globalAnchor.AddV(brokenPhysIsland.globalAnchor);
                    newPhysIsland.resetBoundingRect();
                }
            }
            
            movingTiles = [];
            for each (var islandView:ViewPIsland in islandViews) {
                if (islandView.sprite.isMoving()) {
                    movingTiles.push(islandView);
                }
            }
            
            if (brokenIslandViews.length > 0) {
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
            onFire = onFire.filter(function(tile) {
                return !tile.isDead;
            });
            
            if (gameOverState == Constants.GAME_OVER_FADING) {
                if (player.parent == this) {
                    removeChild(player);
                }
            }
        }
    }

}