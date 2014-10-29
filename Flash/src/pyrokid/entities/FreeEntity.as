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
        
        public function getLeadingCoorInGlobal():Vector2i {
            // TODO -- I'm not 100% sure why this works... -- Aaron, Nick
            var xDiff:int = direction == Constants.DIR_RIGHT ? wArt : 0;
            return new Vector2(x + xDiff, y + hArt / 2).DivD(Constants.CELL).floor();
        }
        
        //protected function constructHitBox(scale:Number, xHit:int = 0, yHit:int = 0, wHit:int = -1, hHit:int = -1):void {
            //hitBox = new Box(xHit * scale, yHit * scale, this.wHit * scale, this.hHit * scale);
        //}
        
        public function set direction(val:int):void {
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
        
        public function update(level:Level):void {
            // TODO try this with water bats or anything that is slightly in the air. Doesn't work
            // because they're on different frames. -- Aaron, Nick, Cristian
            //if (!(this is Player) && isGrounded) {
                //trace("grounded on frame: " + level.frameCount);
            //}
            //if (!(this is Player) && touchTop) {
                //trace("touch top on frame: " + level.frameCount);
            //}
            if (isGrounded && touchTop) {
                var xVelocity:int = (Math.random() * 75 + 25) * (Math.random() > 0.5 ? -1 : 1);
                var constr:Class = Object(this).constructor;
                var newClip:Sprite = new constr(level);
                var deathAnimation:BriefClip = new BriefClip(new Vector2(x, y), newClip, new Vector2(xVelocity, -300), Constants.FADE_TIME, true, true);
                kill(level, deathAnimation);
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
                    // TODO when is the direction not one of these? -- Cristian
                    return;
                }
                var entity:TileEntity = level.tileEntityGrid[cell.y][cell.x];
                // TODO what if the thing is falling? Do we care? -- Aaron
                if (entity != null) {
                    entity.mutualIgnite(level, self);
                }
            };
        }
        
        public function isTouching(sprite:Sprite):Boolean {
            if (sprite is FreeEntity) {
                var freeEntity:FreeEntity = sprite as FreeEntity;
                return hitBox.hitTestObject(freeEntity.hitBox);
            } else {
                return hitBox.hitTestObject(sprite);
            }
        }
	}
	
}