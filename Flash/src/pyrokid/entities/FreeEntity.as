package pyrokid.entities {
	import flash.display.Sprite;
    import physics.*;
    import pyrokid.*;
    import pyrokid.Level;
	
	public class FreeEntity extends GameEntity {
        
        public var isGrounded:Boolean = false;
        public var touchLeft:Boolean = false;
        public var touchRight:Boolean = false;
        public var touchTop:Boolean = false;
        
        private var _collisionCallback:Function;
        
        public function resolveCollision(r:PhysRectangle, a:CollisionAccumulator, o:PhysCallbackOptions):Boolean {
            if (a.accumNY > 0) isGrounded = true;
            if (a.accumPY > 0) touchTop = true;
            if (a.accumNX > 0) touchRight = true;
            if (a.accumPX > 0) touchLeft = true;
            return true;
        }
        
        public function get collisionCallback():Function {
            return _collisionCallback;
        }
        
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
            }
		}
		
		public function FreeEntity(level:Level, width:Number = 1, height:Number = 1, color:uint = uint.MAX_VALUE) {
			super(width, height);
            
            _collisionCallback = genCollisionCallback(level);
            
            if(color != uint.MAX_VALUE && Constants.DEBUG){
			    graphics.lineStyle(0x000000);
			    graphics.beginFill(color);
			    graphics.drawRect(0, 0, w, h);
			    graphics.endFill();
            }
		}
        
        private function genCollisionCallback(level:Level):Function {
            var self:FreeEntity = this;
            return function(edgeOfCollision:PhysEdge, islandAnchor:Vector2):void {
                var center:Vector2 = new Vector2(
                    edgeOfCollision.center.x + islandAnchor.x,
                    edgeOfCollision.center.y + islandAnchor.y
                );
                var cell:Vector2i;
                if (edgeOfCollision.direction == Cardinal.NX) {
                    cell = new Vector2i(center.x, Math.floor(center.y));
                } else if (edgeOfCollision.direction == Cardinal.PX) {
                    cell = new Vector2i(center.x - 1, Math.floor(center.y));
                } else if (edgeOfCollision.direction == Cardinal.NY) {
                    cell = new Vector2i(Math.floor(center.x), center.y);
                } else if (edgeOfCollision.direction == Cardinal.PY) {
                    cell = new Vector2i(Math.floor(center.x), center.y - 1);
                } else {
                    // TODO when is the direction not one of these?
                    return;
                }
                var entity:TileEntity = level.tileEntityGrid[cell.y][cell.x];
                if (entity != null) {
                    var thisOnFire:Boolean = self.isOnFire();
                    var entityOnFire:Boolean = entity.isOnFire();
                    if (entityOnFire) {
                        self.ignite(level, level.frameCount);
                    }
                    if (thisOnFire) {
                        entity.ignite(level, level.frameCount);
                    }
                }
            };
        }
	}
	
}