package pyrokid.tools {
    import physics.Vector2i;
    
    public class BoundingBox {
        
        private var _x:int;
        private var _y:int;
        private var _w:int;
        private var _h:int;
        
        /* x, y is top left corner */
        public function BoundingBox(x:int, y:int, w:int, h:int) {
            _x = x;
            _y = y;
            _w = w;
            _h = h;
        }
        
        public function get x():int {
            return _x;
        }
        
        public function get y():int {
            return _y;
        }
        
        public function get w():int {
            return _w;
        }
        
        public function get h():int {
            return _h;
        }
        
        public function get center():int {
            return new Vector2i(x + w/2, y + h/2);
        }
    }
    
}