package physics {
    import flash.geom.Rectangle;
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
    
        public function Update(dt:Number) {
            motion.Set(velocity.x, velocity.y).MulD(dt);
            center.AddV(motion);
        }
    }

}