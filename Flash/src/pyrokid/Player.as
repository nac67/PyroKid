package pyrokid {
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    import physics.DynamicEntity;
    
    /**
     * Player can be any width <= 50
     * @author Nick Cheng
     */
    public class Player extends DynamicEntity {
        
        private var _direction:int;
        private var _width:Number;
        private var _height:Number;

        public function Player(width:Number, height:Number) {
            super(width, height, 0xCCCCFF);
            
            this._width = width;
            this._height = height;
            
            this.direction = Constants.DIR_RIGHT;
            
            
        }
        
        public function set direction(dir:int) {
            _direction = dir;
            if (dir == Constants.DIR_RIGHT) {
                graphics.clear();
                graphics.lineStyle(0x000000);
                graphics.beginFill(0xCCCCFF);
                graphics.drawRect(0, 0, Constants.CELL * _width, Constants.CELL * _height);
                graphics.endFill();
                graphics.lineStyle(0x000000);
                graphics.beginFill(0x000000);
                graphics.drawRect(10, 0, 30, 20);
                graphics.endFill();
            }
            if (dir == Constants.DIR_LEFT) {
                graphics.clear();
                graphics.lineStyle(0x000000);
                graphics.beginFill(0xCCCCFF);
                graphics.drawRect(0, 0, Constants.CELL * _width, Constants.CELL * _height);
                graphics.endFill();
                graphics.lineStyle(0x000000);
                graphics.beginFill(0x000000);
                graphics.drawRect(0, 0, 30, 20);
                graphics.endFill();
            }
        }
        
        public function get direction() {
            return _direction
        }
    
    }

}
