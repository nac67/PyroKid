package pyrokid.tools {
    import flash.display.Sprite;
    import Vector2i;
    import pyrokid.Constants;
    
    public class Box extends Sprite {
        
        private var _w:int;
        private var _h:int;
        
        /* x, y is top left corner */
        public function Box(x:int, y:int, w:int, h:int) {
            this.x = x;
            this.y = y;
            _w = w;
            _h = h;
            
            graphics.lineStyle(2, 0xFF0000);
            graphics.drawRect(0, 0, w, h);
        
            this.visible = Constants.DEBUG;
        }
        
        public function get w():int {
            return _w;
        }
        
        public function get h():int {
            return _h;
        }
        
        public function get center():Vector2i {
            return new Vector2i(x + w/2, y + h/2);
        }
    }
    
}