package pyrokid.entities {
	import flash.display.Sprite;
    import flash.display.MovieClip;
    import physics.*;
    import pyrokid.*;
    import pyrokid.Level;
    import pyrokid.tools.Box;
	
	public class FreeEntity extends GameEntity {
        
        protected var _direction:int;
        protected var hitBox:Box;
        
        protected var scale:Number;
        protected var wArt:int;
        protected var hArt:int;
        protected var xHit:int;
        protected var yHit:int;
        protected var wHit:int;
        protected var hHit:int;
        
        public var isGrounded:Boolean = false;
        public var touchLeft:Boolean = false;
        public var touchRight:Boolean = false;
        public var touchTop:Boolean = false;
        
        private var _collisionCallback:Function;
        
        public function FreeEntity(level:Level, scale:Number, wArt:int, hArt:int,
                xHit:int = 0, yHit:int = 0, wHit:int = -1, hHit:int = -1) {
            
            this.wArt = wArt;
            this.hArt = hArt;
            this.xHit = xHit;
            this.yHit = yHit;
            if (wHit == -1 || hHit == -1) {
                this.wHit = this.wArt;
                this.hHit = this.hArt;
            } else {
                this.wHit = wHit;
                this.hHit = hHit;
            }
            this.scale = scale;
            
            hitBox = new Box(xHit * scale, yHit * scale, this.wHit * scale, this.hHit * scale);
            addChild(hitBox);
            
            _collisionCallback = genCollisionCallback(level);
            
            if(Constants.DEBUG) {
			    graphics.lineStyle(1, 0x000000);
			    graphics.beginFill(0x8888FF);
			    graphics.drawRect(0, 0, wArt * scale, hArt * scale);
			    graphics.endFill();
            }
        }
        
        public function set direction (val:int):void {
            _direction = val;
        }
        
        public function get direction():int {
            return _direction;
        }
        
        /* Returns the center of the object in pixel space W.R.T. the level*/
        public function getCenter():Vector2i {
            return getCenterLocal().Add(x, y);
        }
        
        /* Returns the center of the object in pixel space W.R.T. this*/
        public function getCenterLocal():Vector2i {
            return new Vector2i((wArt / 2), (hArt / 2));
        }
        
        public function genPhysRect():PhysRectangle {
            var enemyRect:PhysRectangle = new PhysRectangle();
            enemyRect.halfSize = new Vector2(wArt * scale / 2, hArt * scale / 2).DivD(Constants.CELL);
            return enemyRect;
        }
        
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