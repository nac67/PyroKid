package pyrokid.entities {
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
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
        
        protected var timeSinceHitCeiling:int = 0;
        
        private var _collisionCallback:Function;
                
        private var glowSprite:Sprite = new Sprite();
        private var glowImage:Bitmap = new Embedded.GlowBMP() as Bitmap;
       
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
            
            glowSprite.addChild(glowImage);
            glowImage.x = -glowImage.width / 2;
            glowImage.y = -glowImage.height / 2;
            
            
            addChild(glowSprite);
            glowSprite.x = this.wHit * 0.5;
            glowSprite.y = this.hHit * 0.5;
            
            glow = 1.0;
            glowRadius = this.wHit + this.hHit * 0.25;
            glowVisible = false;
        }
        
        public function getLeadingCoorInGlobal():Vector2i {
            // TODO -- I'm not 100% sure why this works... -- Aaron, Nick
            var xDiff:int = direction == Constants.DIR_RIGHT ? wArt : 0;
            return new Vector2(x + xDiff, y + hArt / 2).DivD(Constants.CELL).floor();
        }
        
        public function getCurrentCoorInGlobal():Vector2i {
            return new Vector2(x + wArt / 2, y + hArt / 2).DivD(Constants.CELL).floor();
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
            enemyRect.halfSize.Set(wArt * scale / 2, hArt * scale / 2).DivD(Constants.CELL);
            return enemyRect;
        }
        
        public function resolveCollision(r:PhysRectangle, a:CollisionAccumulator, o:PhysCallbackOptions):Boolean {
            if (a.accumNY > 0) isGrounded = true;
            if (a.accumPY > 0) {
                o.breakYVelocity = false;
                touchTop = true;
            }
            if (a.accumNX > 0) touchRight = true;
            if (a.accumPX > 0) touchLeft = true;
            
            if (!o.breakYVelocity) {
                timeSinceHitCeiling += 1;
                if (timeSinceHitCeiling > Constants.PLAYER_CEILING_HANG_TIME) {
                    o.breakYVelocity = true;
                    timeSinceHitCeiling = 0;
                }
            }
            
            return true;
        }
        
        public function get entityWidth():int {
            return wArt * scale;
        }
        
        public function get entityHeight():int {
            return hArt * scale;
        }
        
        public function get collisionCallback():Function {
            return _collisionCallback;
        }
        
        /* Set Glow Properties Of The Sprite */
        public function set glow(hue:Number):void {
            var r:Number = 0.0;
            var g:Number = 0.0;
            var b:Number = 0.0;
            
            var c:Number = 1;
            var x:Number = (1 - Math.abs(((3.0 * hue / Math.PI) % 2.0) - 1.0));
            var p:int = (int)(3.0 * hue / Math.PI);
            switch (p) {
            case 0:
                r = 1;
                g = x;
                break;
            case 1:
                g = 1;
                r = x;
                break;
            case 2:
                g = 1;
                b = x;
                break;
            case 3:
                b = 1;
                g = x;
                break;
            case 4:
                b = 1;
                r = x;
                break;
            case 5:
                r = 1;
                b = x;
                break;
            default:
                break;
            }
            
            var ct:ColorTransform = new ColorTransform(
                r * 0.3, g * 0.3, b * 0.3, 0.5,
                150, 150, 150, 0
                );
            glowSprite.transform.colorTransform = ct;
        }
        public function set glowRadius(r:Number):void {
            glowImage.width = r * 2;
            glowImage.height = r * 2;
            glowImage.x = -r;
            glowImage.y = -r;
        }
        public function set glowVisible(isVisible:Boolean):void {
            glowSprite.visible = isVisible;
        }
        
		public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            return super.ignite(level, coor, dir);
		}
        
        protected function isBeingSmooshed():Boolean {
            // TODO this doesn't quite cut it.
            return isGrounded && touchTop;
        }
        
        public function update(level:Level):void {
            if (this is WaterBat) {
                if (touchTop) {
                    velocity.y = 5;
                } else {
                    velocity.y = 0;
                }
                if (velocity.y == 0) {
                    Utils.centerInCellVert(this, Math.round(getCenter().y / Constants.CELL));
                }
            }
            if (isBeingSmooshed()) {
                var xVelocity:int = (Math.random() * 75 + 25) * (Math.random() > 0.5 ? -1 : 1);
                var constr:Class = Object(this).constructor;
                var newClip:FreeEntity = new constr(level);
                
                //the reason for this poop line following is because BriefClips are
                //centered by width/height properties, which change based on the contents
                //of the sprite. ew
                newClip.removeChild(newClip.glowSprite);
                
                if (GameSettings.soundOn) Embedded.squishSound.play();
                
                var deathAnimation:BriefClip = new BriefClip(new Vector2(x, y), newClip, new Vector2(xVelocity, -300), Constants.FADE_TIME, true, Constants.DEATH_CLIP_TYPE_SMOOSH);
                 if (newClip is Player) {
                    level.smooshedPlayer = deathAnimation;
                }
                kill(level, deathAnimation, Constants.DEATH_BY_SMOOSH);
            }
        }
		
        private function genCollisionCallback(level:Level):Function {
            var self:FreeEntity = this;
            return function(edgeOfCollision:PhysEdge, islandAnchor:Vector2):void {
                var center:Vector2 = new Vector2(
                    edgeOfCollision.center.x,
                    edgeOfCollision.center.y
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
                var dir:int = Cardinal.getOpposite(edgeOfCollision.direction);
                var entity:TileEntity = Utils.index(level.tileEntityGrid, cell.x, cell.y);
                // TODO what if the thing is falling? Do we care? -- Aaron
                // TODO this is all copy and pasted and is terrible style -- Aaron
                if (entity != null) {
                    var coor:Vector2i = new Vector2i(cell.x, cell.y).SubV(entity.getGlobalAnchorAsVec2i());
                    var thisOnFire:Boolean = self.isOnFire();
                    var thisIsWater:Boolean = self is WaterBat;
                    var entityOnFire:Boolean = entity.isOnFire();
                    if (!thisIsWater) {
                        if (entityOnFire && entity.canIgniteFrom(coor, edgeOfCollision.direction)) {
                            self.ignite(level);
                        }
                        if (thisOnFire) {
                            entity.ignite(level, coor, dir);
                        }
                    } else {
                        if (entityOnFire && entity.canIgniteFrom(coor, edgeOfCollision.direction)) {
                            if (entity is BurnForever) {
                                BurnForever(entity).douse(level);
                            }
                        }
                    }
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