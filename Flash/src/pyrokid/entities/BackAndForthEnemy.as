package pyrokid.entities {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import physics.PhysRectangle;
    import Vector2i;
    import pyrokid.*;
    import flash.display.MovieClip;
    import Vector2;
    import pyrokid.tools.Box;
    import Utils;
    
    /* This is an "abstract" class. Do not instantiate. Use a subclass that
     * is a specific type of enemy. */
    public class BackAndForthEnemy extends FreeEntity {
        
        protected var swf:Sprite;
        protected var gravity:Boolean;
        
        protected var health:int;
        
        public function BackAndForthEnemy(level:Level, swf:Sprite, scale:Number, wArt:int, hArt:int,
                xHit:int = 0, yHit:int = 0, wHit:int = -1, hHit:int = -1, gravity:Boolean = true) {
            super(level, scale, wArt, hArt, xHit, yHit, wHit, hHit);

            this.swf = swf;
            addChild(swf);
            swf.scaleX = swf.scaleY = scale;
            
            this.gravity = gravity;
            direction = Constants.DIR_RIGHT;
            
            if (Constants.DEBUG) {
                setChildIndex(this.swf, 0);
            }
        }
        
        public override function set direction(val:int):void {
            _direction = val;
            if (val == Constants.DIR_RIGHT) {
                swf.scaleX = scale;
                swf.x = 0;
                hitBox.x = xHit * scale;
                hitBox.scaleX = 1;
            } else {
                swf.scaleX = -scale;
                swf.x = scale * wArt;
                hitBox.x = scale * wArt - (xHit * scale);
                hitBox.scaleX = -1;
            }
        }
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            if (health > 1) {
                health --;
                return false;
            } else {
                return super.ignite(level, coor, dir);
            }
		}
        
        public override function update(level:Level):void {
            super.update(level);
            var leadingCoor:Vector2i = getLeadingCoorInGlobal();
            var leadingEntity:TileEntity = Utils.index(level.tileEntityGrid, leadingCoor.x, leadingCoor.y);
            var belowLeadingEntity:TileEntity = Utils.index(level.tileEntityGrid, leadingCoor.x, leadingCoor.y + 1);
            if (gravity && velocity.y == 0 && leadingEntity == null && belowLeadingEntity == null) {
                if (direction == Constants.DIR_RIGHT) {
                    direction = Constants.DIR_LEFT;
                } else {
                    direction = Constants.DIR_RIGHT;
                }
            }
            
            if (touchRight) {
                direction = Constants.DIR_LEFT;
            } else if (touchLeft) {
                direction = Constants.DIR_RIGHT;
            }
            
            if (gravity) {
                velocity.Add(0, Constants.GRAVITY * Constants.CELL * Constants.DT);
            }
            velocity.Set((direction == Constants.DIR_RIGHT ? 
                    Constants.SPIDER_SPEED : -Constants.SPIDER_SPEED), velocity.y);
        }
    }
    
}