package pyrokid.entities {
    import flash.display.DisplayObject;
    import physics.PhysRectangle;
    import pyrokid.*;
    import flash.display.MovieClip;
    import physics.Vector2;
    
    /* This is an "abstract" class. Do not instantiate. Use a subclass that
     * is a specific type of enemy. */
    public class BackAndForthEnemy extends FreeEntity {
        
        private var _direction:int;
        protected var swf:MovieClip;
        
        private var scale:Number;
        private var wArt:int;
        private var hArt:int;
        private var xHit:int;
        private var yHit:int;
        private var wHit:int;
        private var hHit:int;
        
        public function BackAndForthEnemy(level:Level, swf:MovieClip,
                scale:Number, wArt:int, hArt:int, xHit:int = 0, yHit:int = 0, wHit:int = -1, hHit:int = -1) {
            super(level, wArt*scale, hArt*scale, 0x00FF00);
            
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
            
            this.swf = swf;
            addChild(swf);
            this.scale = scale;
            swf.scaleX = swf.scaleY = scale;
            direction = Constants.DIR_RIGHT;
        }
        
        public function genPhysRect():PhysRectangle {
            var enemyRect:PhysRectangle = new PhysRectangle();
            enemyRect.halfSize = new Vector2(wArt * scale / 2, hArt * scale / 2).DivD(Constants.CELL);
            return enemyRect;
        }
        
        public function set direction (val:int):void {
            _direction = val;
            if (val == Constants.DIR_RIGHT) {
                swf.scaleX = scale;
                swf.x = 0;
            } else {
                swf.scaleX = -scale;
                swf.x = scale * wArt;
            }
        }
        
        public function get direction ():int {
            return _direction;
        }
        
        public function update():void {
            if (touchRight) {
                direction = Constants.DIR_LEFT;
            }else if (touchLeft) {
                direction = Constants.DIR_RIGHT;
            }
            
            velocity.Add(0, Constants.GRAVITY * Constants.CELL * Constants.DT);
            velocity.Set((direction == Constants.DIR_RIGHT ? 
                    Constants.SPIDER_SPEED : -Constants.SPIDER_SPEED), velocity.y);
        }
    }
    
}