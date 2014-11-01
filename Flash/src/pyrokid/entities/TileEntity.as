package pyrokid.entities {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.utils.Dictionary;
	import physics.*;
	import pyrokid.*;
    import pyrokid.tools.HashSet;
    import Utils;
    import pyrokid.graphics.ConnectedSpriteBuilder;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
        // maps coor with respect to entity to edges from that coor.
        // edges represented by an array of booleans of length 4,
        // indices corresponding to Cardinal.DIRECTIONS
        private var edges:Dictionary;
        
        private var neighborCells:Array;
        // position, in tile coordinates, relative to the corner of the island.
        public var islandAnchor:Vector2i;
        public var parentIsland:Island;
        public var cellSprites:Array;
        protected var objectCode:int;
		
		public function TileEntity(x:int, y:int, objCode:int) {
            objectCode = objCode;
			this.x = x;
			this.y = y;
			cells = [];
            cellSprites = [];
		}
        
        /* Returns an array of tile coordinates this TileEntity occupies
         * with respect to the global map. Coordinates are Vector2, which
         * means they can be between tiles (if the island is falling, for example). */
        public function coorsInGlobal():Array {
            return getCoorsInGlobal(cells);
        }
        
        /* Returns an array of tile coordinates this TileEntity occupies
         * with respect to the island it is in. Coordinates are Vector2i
         * because a TileEntity never moves out of sync with its parent island. */
        public function coorsInIsland():Array {
            return getCoorsInIsland(cells);
        }
        
        private function neighborsInGlobal():Array {
            return getCoorsInGlobal(neighborCells);
        }
        
        private function neighborsInIsland():Array {
            return getCoorsInIsland(neighborCells);
        }
        
        private function getCoorsInGlobal(coors:Array):Array {
            var globalA:Vector2 = getGlobalAnchor();
            return coors.map(function(coor) {
                return coor.copyAsVec2().AddV(globalA);
            });
        }
        
        private function getCoorsInIsland(coors:Array):Array {
            return coors.map(function(coor) {
                return islandAnchor.copy().AddV(coor);
            });
        }
        
        public function getGlobalAnchor():Vector2 {
            return parentIsland.globalAnchor.copy().AddV(islandAnchor.copyAsVec2());
        }
        
        private function getGlobalAnchorAsVec2i():Vector2i {
            return parentIsland.globalAnchor.copyAsVec2i().AddV(islandAnchor);
        }
		
		protected function getSpriteForCell(cell:Vector2i):DisplayObject {
            trace("This is an \"Abstract Method\" and you should never see this printed out");
            return null;
		}
        
        private function isFlammable():Boolean {
            return objectCode != Constants.METAL_TILE_CODE && objectCode != Constants.WALL_TILE_CODE;
        }
		
		public function finalizeCells():void {
            var tileSetMap:Bitmap = Constants.GET_TILE_SET(objectCode);
            if (tileSetMap != null) {
                var tileSet:Bitmap = ConnectedSpriteBuilder.buildSpriteFromCoors(cells, tileSetMap);
                addChild(tileSet);
                for each (var cell:Vector2i in cells) {
                    var fire:DisplayObject = new Embedded.FireTileSWF() as MovieClip;
                    fire.x = cell.x * Constants.CELL;
                    fire.y = cell.y * Constants.CELL;
                    cellSprites.push(fire);
                }
            } else {
                for (var i:int = 0; i < cells.length; i++) {
                    var child:DisplayObject = getSpriteForCell(cells[i]);
                    child.x = cells[i].x * Constants.CELL;
                    child.y = cells[i].y * Constants.CELL;
                    addChild(child);
                    cellSprites.push(child);
                }
            }
            
            edges = new Dictionary();
            
            var neighbors:HashSet = new HashSet();
            for each (var cell:Vector2i in cells) {
                edges[cell.toString()] = [false, false, false, false];
                for each (var neighborCoor:Vector2i in Utils.getNeighborCoors(cell.x, cell.y)) {
                    neighbors.add(neighborCoor);
                }
            }
            for each (var cell:Vector2i in cells) {
                neighbors.remove(cell);
            }
            neighborCells = neighbors.toArray();
		}
        
        public function spreadToNeighbors(level:Level):void {
            var fireGrid:Array = isMoving() ? parentIsland.tileEntityGrid : level.tileEntityGrid;
            var coorOffset:Vector2i = isMoving() ? islandAnchor.copy() : getGlobalAnchorAsVec2i();
            for each (var coor:Vector2i in cells) {
                var coorEdges:Array = edges[coor.toString()];
                for each (var dir:int in Cardinal.DIRECTIONS) {
                    var otherCoor:Vector2i = Cardinal.getVector2i(dir).AddV(coor);
                    if (!coorEdges[dir] && cells.indexOf(otherCoor) == -1) {
                        var neiCoor:Vector2i = otherCoor.copy().AddV(coorOffset);
                        var neiEntity:TileEntity = Utils.index(fireGrid, neiCoor.x, neiCoor.y);
                        if (neiEntity != null) {
                            var neiCoorOffset:Vector2i = isMoving() ? neiEntity.islandAnchor.copy() : neiEntity.getGlobalAnchorAsVec2i();
                            neiCoor.SubV(neiCoorOffset);
                            neiEntity.ignite(level, neiCoor, dir);
                        }
                    }
                }
            }
            //var neighborCoors:Array = isMoving() ? neighborsInIsland()
                    //: neighborsInGlobal().map(function(coor) { return coor.copyAsVec2i(); } );
            //for each (var neiCoor:Vector2i in neighborCoors) {
                //var neiEntity:TileEntity = Utils.index(fireGrid, neiCoor.x, neiCoor.y);
                //if (neiEntity != null) {
                    //neiEntity.ignite(level);
                //}
            //}
        }
		
        /* coor is which coordinate with respect to the entity's top left corner.
         * dir is the direction FROM the coor doing the igniting TO the coor being
         * ignited (coor param). */
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):void {
            if (!isOnFire()) {
                trace("ignited from direction " + dir + " at coor " + coor);
                super.ignite(level);
                level.onFire.push(this);
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            
        }
		
		
	}
	
}