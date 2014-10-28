package pyrokid {
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import physics.PhysIsland;
    import Vector2;
    import Vector2i;
    import pyrokid.entities.TileEntity;
    import Utils;
    
    public class Island {
        
        private var _velocity:Vector2;
        private var _globalAnchor:Vector2;
        public var tileEntityGrid:Array;
        public var entityList:Array;
        public var connectors:Dictionary;
        
        public function Island(physIsland:PhysIsland) {
            entityList = [];
            connectors = new Dictionary();
            tileEntityGrid = Utils.newArrayOfSize(physIsland.tileGrid);
            _velocity = physIsland.velocity.copy().MulD(Constants.CELL);
            _globalAnchor = physIsland.globalAnchor.copy();
        }
        
        /* Adds entity to this island, given that entity's top left corner is
         * located at globalAnchor with respect to the entire map. */
        public function addEntity(entity:TileEntity, entityGlobalAnchor:Vector2):void {
            entity.parentIsland = this;
            entity.islandAnchor = entityGlobalAnchor.copy().SubV(globalAnchor).copyAsVec2i();
            for each (var cell:Vector2i in entity.coorsInIsland()) { // relative to entity's anchor
                if (!Utils.inBounds(tileEntityGrid, cell.x, cell.y)) {
                    trace("cell " + cell + " is not in bounds");
                }
                tileEntityGrid[cell.y][cell.x] = entity;
            }
            entityList.push(entity);
        }
        
        public function get velocity():Vector2 {
            return _velocity;
        }
        
        public function set velocity(value:Vector2):void {
            _velocity = value;
            for each (var entity:TileEntity in entityList) {
                entity.velocity = _velocity;
            }
        }
        
        public function isMoving():Boolean {
            return velocity.x + velocity.y != 0;
        }
        
        public function get globalAnchor():Vector2 {
            return _globalAnchor;
        }
        
        public function getAnchorAsInt():Vector2i {
            return new Vector2i(Math.round(globalAnchor.x), Math.round(globalAnchor.y));
        }
        
        public function setConnectorPositions():void {
            for each (var connector:Connector in connectors) {
                connector.setSpriteLocationFromIslandAnchor(globalAnchor);
            }
        }
        
        public function set globalAnchor(value:Vector2):void {
            _globalAnchor = value;
            for each (var entity:TileEntity in entityList) {
                entity.x = (value.x + entity.islandAnchor.x) * Constants.CELL;
                entity.y = (value.y + entity.islandAnchor.y) * Constants.CELL;
            }
            setConnectorPositions();
        }
        
    }
    
}