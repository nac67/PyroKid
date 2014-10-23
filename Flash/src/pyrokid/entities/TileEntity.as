package pyrokid.entities {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
	import physics.*;
	import pyrokid.*;
    import pyrokid.tools.HashSet;
    import pyrokid.tools.Utils;
    import pyrokid.graphics.ConnectedSpriteBuilder;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
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
        
        public function neighborsInGlobal():Array {
            return getCoorsInGlobal(neighborCells);
        }
        
        public function neighborsInIsland():Array {
            return getCoorsInIsland(neighborCells);
        }
        
        public function getCoorsInGlobal(coors:Array):Array {
            var globalA:Vector2 = getGlobalAnchor();
            return coors.map(function(coor) {
                return coor.copyAsVec2().AddV(globalA);
            });
        }
        
        public function getCoorsInIsland(coors:Array):Array {
            return coors.map(function(coor) {
                return islandAnchor.copy().AddV(coor);
            });
        }
        
        public function getGlobalAnchor():Vector2 {
            return parentIsland.globalAnchor.copy().AddV(islandAnchor.copyAsVec2());
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
            var neighbors:HashSet = new HashSet();
            for each (var cell:Vector2i in cells) {
                for each (var neighborCoor:Vector2i in Utils.getNeighborCoors(cell.x, cell.y)) {
                    neighbors.add(neighborCoor);
                }
            }
            for each (var cell:Vector2i in cells) {
                neighbors.remove(cell);
            }
            neighborCells = neighbors.toArray();
		}
		
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                level.onFire.push(this);
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            
        }
		
		
	}
	
}