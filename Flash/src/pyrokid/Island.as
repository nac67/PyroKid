package pyrokid {
    import physics.Vector2;
    import physics.Vector2i;
    import pyrokid.entities.TileEntity;
    import pyrokid.tools.Utils;
    
    public class Island {
        
        private var _velocity:Vector2 = new Vector2();
        private var _globalAnchor:Vector2 = new Vector2();
        public var tileEntityGrid:Array;
        public var entityList:Array;
        
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
        
        public function set globalAnchor(value:Vector2):void {
            var movement:Vector2 = value.copy().SubV(_globalAnchor);
            _globalAnchor = value;
            for each (var entity:TileEntity in entityList) {
                entity.x += (movement.x * Constants.CELL);
                entity.y += (movement.y * Constants.CELL);
            }
        }
        
    }
    
}