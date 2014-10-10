package physics {
    import flash.geom.Rectangle;
    import pyrokid.Constants;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysRectangle {
        public var center:Vector2 = new Vector2();
        public var halfSize:Vector2 = new Vector2(1, 1);
        
        public var velocity:Vector2 = new Vector2();
        public var motion:Vector2 = new Vector2();
        
        public function get NX():Number {
            return center.x - halfSize.x;
        }
        public function get PX():Number {
            return center.x + halfSize.x;
        }
        public function get NY():Number {
            return center.y - halfSize.y;
        }
        public function get PY():Number {
            return center.y + halfSize.y;
        }
    
        public function Update():void {
            motion.SetV(velocity).MulD(Constants.DT);
            motion.x = CollisionResolver.ClampedMotion(motion.x);
            motion.y = CollisionResolver.ClampedMotion(motion.y);
            center.AddV(motion);
        }
    }

}