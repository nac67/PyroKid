package pyrokid.entities {
    import flash.display.DisplayObject;
    import pyrokid.*;
    import flash.display.MovieClip;
    
    public class BackAndForthEnemy extends FreeEntity {
        
        private var _direction:int;
        private var swf:DisplayObject;
        protected var _isDead:Boolean = false;
        
        public function BackAndForthEnemy(level:Level, width:Number, height:Number, swf:DisplayObject) {
            super(level, width, height);
            this.swf = swf;
            addChild(swf);
            direction = Constants.DIR_RIGHT;
        }
        
        public function set direction (val:int):void {
            _direction = val;
            if (val == Constants.DIR_RIGHT) {
                swf.scaleX = -.8;
                swf.x = 47
            }else {
                swf.scaleX = .8;
                swf.x = 0;
            }
        }
        
        public function get isDead():Boolean {
            return _isDead;
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