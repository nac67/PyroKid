package pyrokid.world {
    import flash.display.Sprite;
    import pyrokid.Constants;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class Camera extends Sprite {
        private var world:Sprite;
        
        public function Camera(_world:Sprite) {
            world = _world;
            addChild(world);
        }
        
        public function set xCamera(x:Number):void {
            world.x = -x;
        }
        public function get xCamera():Number {
            return -world.x;
        }

        public function set yCamera(y:Number):void {
            world.y = -y;
        }
        public function get yCamera():Number {
            return -world.y;
        }
        
        public function set rotationCamera(r:Number):void {
            rotation = r;
        }
        public function get rotationCamera():Number {
            return rotation;
        }

        public function scaleCamera(s:Number):void {
            scaleX *= s;
            scaleY *= s;
        }
    
    }
}