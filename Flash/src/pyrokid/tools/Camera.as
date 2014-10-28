package pyrokid.tools {
    import flash.display.Sprite;
    import pyrokid.Constants;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class Camera extends Sprite {
        private var world:Sprite;
        private var scale:Number = 1.0;
        private var baseScale:Number = 1.0;
        
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

        public function set scaleCamera(s:Number):void {
            scale = s;
            scaleX = baseScale * scale;
            scaleY = baseScale * scale;
        }
        public function get scaleCamera():Number {
           return scale;
        }
        public function tareScale(s:Number):void {
            scale = 1.0;
            baseScale = s;
            scaleX = baseScale;
            scaleY = baseScale;
        }
    }
}