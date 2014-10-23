package pyrokid.entities {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import physics.PhysRectangle;
    import pyrokid.*;
    import flash.display.MovieClip;
    import physics.Vector2;
    import pyrokid.tools.Box;
    
    /* This is an "abstract" class. Do not instantiate. Use a subclass that
     * is a specific type of enemy. */
    public class BackAndForthEnemy extends FreeEntity {
        
        protected var swf:MovieClip;
        
        public function BackAndForthEnemy(level:Level, swf:MovieClip, scale:Number, wArt:int, hArt:int,
                xHit:int = 0, yHit:int = 0, wHit:int = -1, hHit:int = -1) {
            super(level, scale, wArt, hArt, xHit, yHit, wHit, hHit);

            this.swf = swf;
            addChild(swf);
            swf.scaleX = swf.scaleY = scale;
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
        
        public override function update(level:Level):void {
            super.update(level);
            if (touchRight) {
                direction = Constants.DIR_LEFT;
            } else if (touchLeft) {
                direction = Constants.DIR_RIGHT;
            }
            
            velocity.Add(0, Constants.GRAVITY * Constants.CELL * Constants.DT);
            velocity.Set((direction == Constants.DIR_RIGHT ? 
                    Constants.SPIDER_SPEED : -Constants.SPIDER_SPEED), velocity.y);
        }
    }
    
}