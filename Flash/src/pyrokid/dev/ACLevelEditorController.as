package pyrokid.dev {
    import flash.display.Sprite;
    import flash.geom.Point;
    import pyrokid.Constants;
    import pyrokid.Level;
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public class ACLevelEditorController extends Sprite {
        private var _level:Level = null;
        
        public function ACLevelEditorController(l:Level) {
            super();
            level = l;
        }
        
        public function set level(l:Level):void {
            _level = l;
        }
        public function get level():Level {
            return _level;
        }
    
        public function hookLogic() {
            throw new Error("Absract Method Not Overriden")
        }
        public function unhookLogic() {
            throw new Error("Absract Method Not Overriden")
        }
        
        protected function getPositionInLevel(mx:Number, my:Number):Point {
            return level.globalToLocal(new Point(mx, my));
        }
        protected function getCellInLevel(mx:Number, my:Number):Vector2i {
            var p:Point = getPositionInLevel(mx, my);
            return new Vector2i(p.x, p.y).DivD(Constants.CELL);
        }
    }
    
}