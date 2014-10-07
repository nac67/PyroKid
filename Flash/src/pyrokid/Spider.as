package pyrokid {
    import flash.display.MovieClip;
    import physics.PhysBox;
    import physics.PhysRectangle;
    import pyrokid.entities.FreeEntity;
    public class Spider extends FreeEntity {
        
        var _direction:int;
        var swf:MovieClip;
        
        public function Spider(width:Number, height:Number) {
            super(width, height);
            
            swf = new Embedded.SpiderSWF();
            swf.scaleY = .8
            swf.x = 47;
            swf.y = -10;
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
        
        public function get direction ():int {
            return _direction;
        }
        
        public function update(phys:PhysRectangle) {
            if (touchRight) {
                direction = Constants.DIR_LEFT;
            }else if (touchLeft) {
                direction = Constants.DIR_RIGHT;
            }
            
            phys.velocity.Add(0, Constants.GRAVITY * Constants.dt);
            phys.velocity.Set((direction == Constants.DIR_RIGHT ? 
                    Constants.SPIDER_SPEED : -Constants.SPIDER_SPEED), phys.velocity.y);
        }
    
    }

}