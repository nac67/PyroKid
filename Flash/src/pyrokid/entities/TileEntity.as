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
        public var fireSprites:Array;
        protected var objectCode:int;
        
        private var connectors:Dictionary;
        private var partnerConnectors:Array;
        
        public var visualCells:Array; // DON'T USE THIS. IT IS FOR TUTORIALS ONLY.
        		
		public function TileEntity(x:int, y:int, objCode:int) {
            objectCode = objCode;
			this.x = x;
			this.y = y;
			cells = [];
            fireSprites = [];
            visualCells = [];
            connectors = new Dictionary();
            partnerConnectors = [];
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
        
        public function getGlobalAnchorAsVec2i():Vector2i {
            return parentIsland.globalAnchor.copyAsVec2i().AddV(islandAnchor);
        }
		
		protected function getSpriteForCell(cell:Vector2i):DisplayObject {
            trace("This is an \"Abstract Method\" and you should never see this printed out");
            return null;
		}
        
        private function isFlammable():Boolean {
            return objectCode != Constants.METAL_TILE_CODE && objectCode != Constants.WALL_TILE_CODE;
        }
        
        public function addFireLocation(relativeCell:Vector2i):void {
            var fire:DisplayObject = new Embedded.FireTileSWF() as MovieClip;
            fire.x = relativeCell.x * Constants.CELL;
            fire.y = relativeCell.y * Constants.CELL;
            fireSprites.push(fire);
        }
		
		public function finalizeCells(level:Level, globalAnchor:Vector2i):void {
            var tileSetMap:Bitmap = Constants.GET_TILE_SET(objectCode);
            if (tileSetMap != null) {
                var tileSet:Bitmap = ConnectedSpriteBuilder.buildSpriteFromCoors(cells, globalAnchor, objectCode == Constants.WALL_TILE_CODE, tileSetMap, level.cellWidth, level.cellHeight);
                addChild(tileSet);
                for each (var cell:Vector2i in cells) {
                    addFireLocation(cell);
                }
            } else {
                for (var i:int = 0; i < cells.length; i++) {
                    var child:DisplayObject = getSpriteForCell(cells[i]);
                    child.x = cells[i].x * Constants.CELL;
                    child.y = cells[i].y * Constants.CELL;
                    addChild(child);
                    fireSprites.push(child);
                }
            }
            
            edges = new Dictionary();
            
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
        
        public function removePartnerConnectors():void {
            for each (var partnerConn:Array in partnerConnectors) {
                var oppositeEntity:TileEntity = partnerConn[0];
                var child:Sprite = partnerConn[1];
                oppositeEntity.removeChild(child);
                oppositeEntity.partnerConnectors.filter(function(item:Array, i:int, a:Array):Boolean {
                    return item[0] != this;
                });
            }
        }
        
        public function clearConnectorDict():void {
            connectors = null;
        }
        
        public function setUpPartnerConnectors():void {
            for each (var value:Array in connectors) {
                var coor:Vector2i = value[0];
                var dir:int = value[1];
                var oppositeCoorInIsland:Vector2i = Cardinal.getVector2i(dir).AddV(coor);
                var oppositeDir:int = Cardinal.getOpposite(dir);
                var oppositeEntity:TileEntity = Utils.index(parentIsland.tileEntityGrid, oppositeCoorInIsland.x, oppositeCoorInIsland.y);
                var connectorKey:String = Connector.coorAndDirToString(oppositeCoorInIsland, oppositeDir);
                var oppositeConnectorArr:Array = oppositeEntity.connectors[connectorKey];
                var child:Sprite = oppositeConnectorArr[2];
                partnerConnectors.push([oppositeEntity, child]);
            }
        }
        
        public function addEdges(levelRecipeEdges:Array, connector:Boolean = false):void {
            for each (var cell:Vector2i in cells) {
                var cellInGlobal:Vector2i = getGlobalAnchorAsVec2i().AddV(cell);
                var edgeBools:Array = Utils.getBooleansFromInt(levelRecipeEdges[cellInGlobal.y][cellInGlobal.x]);
                if (!connector) {
                    edges[cell.toString()] = edgeBools;
                }
                
                for (var dir:int = 0; dir < 4; dir++) {
                    if (edgeBools[dir]) {
                        addEdge(cell, dir, connector);
                    }
                }
            }
        }
        
        private function addEdge(cell:Vector2i, dir:int, connector:Boolean):void {
            var child:DisplayObject;
            var edgeType:int;
            if (connector) {
                child = new Embedded.ConnectorSWF() as Sprite;
                child.scaleX = child.scaleY = 0.7;
                edgeType = Constants.CONNECTOR_CODE;
                var islandCoor:Vector2i = cell.copy().AddV(islandAnchor);
                connectors[Connector.coorAndDirToString(islandCoor, dir)] = [islandCoor, dir, child];
            } else {
                child = new Embedded.MetalEdgeBMP() as Bitmap;
                edgeType = Constants.METAL_EDGE_CODE;
            }
            child.rotation = getEdgeRotation(dir, edgeType);
            var edgeOffset:Vector2i = getEdgeOffset(dir, edgeType);
            child.x = cell.x * Constants.CELL + edgeOffset.x;
            child.y = cell.y * Constants.CELL + edgeOffset.y;
            addChild(child);
        }
        
        private static function getEdgeOffset(dir:int, edgeType:int):Vector2i {
            switch (edgeType) {
                case Constants.CONNECTOR_CODE:
                    switch (dir) {
                        case Cardinal.NX: return new Vector2i(0, Constants.CELL / 2);
                        case Cardinal.PX: return new Vector2i(Constants.CELL, Constants.CELL / 2);
                        case Cardinal.NY: return new Vector2i(Constants.CELL / 2, 0);
                        case Cardinal.PY: return new Vector2i(Constants.CELL / 2, Constants.CELL);
                    }
                    break;
                case Constants.METAL_EDGE_CODE:
                    switch (dir) {
                        case Cardinal.NX: return new Vector2i(0, Constants.CELL);
                        case Cardinal.PX: return new Vector2i(Constants.CELL, 0);
                        case Cardinal.NY: return new Vector2i(0, 0);
                        case Cardinal.PY: return new Vector2i(Constants.CELL, Constants.CELL);
                    }
                    break;
            }
            return null;
        }
        
        private static function getEdgeRotation(dir:int, edgeType:int):int {
            switch (edgeType) {
                case Constants.CONNECTOR_CODE:
                    return dir == Cardinal.NY || dir == Cardinal.PY ? 90 : 0;
                case Constants.METAL_EDGE_CODE:
                    switch (dir) {
                        case Cardinal.NX: return 270;
                        case Cardinal.PX: return 90;
                        case Cardinal.NY: return 0;
                        case Cardinal.PY: return 180;
                    }
                    break;
            }
            return 0;
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
        
        public function canIgniteFrom(coor:Vector2i, dir:int):Boolean {
            return !edges[coor.toString()][dir];
        }
		
        // EWW this function is awfully written
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            if (isOnFire()) {
                return false;
            }
            
            if (coor == null) {
                level.onFire.push(this);
                return super.ignite(level, coor, dir);
            }
            
            var isEdge:Boolean = edges[coor.toString()][Cardinal.getOpposite(dir)];
            if (!isEdge) {
                level.onFire.push(this);
                super.ignite(level, coor, dir);
            }
            return !isEdge;
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            
        }
		
		
	}
	
}