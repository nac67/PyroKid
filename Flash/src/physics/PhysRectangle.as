package physics {
    import flash.geom.Rectangle;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysRectangle {
        public var center:Vector2;
        public var halfSize:Vector2;
        
        public var motion:Vector2;
        
        public function PhysRectangle() {
            center = new Vector2().Set(0, 0);
            halfSize = new Vector2().Set(1, 1);
            motion = new Vector2().Set(0, 0);
        }
        
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
    }

}