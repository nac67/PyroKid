package physics {
	import flash.display.Sprite;
    import flash.geom.Rectangle;
	import pyrokid.Constants;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysRectangle extends Sprite {
        private var _center:Vector2 = new Vector2();
        public var halfSize:Vector2 = new Vector2(1, 1);
        
        public var velocity:Vector2 = new Vector2();
        public var motion:Vector2 = new Vector2();
		
		public function PhysRectangle(width:Number, height:Number) {
			_center = new Vector2(0, 0, updateSpriteX, updateSpriteY);
			halfSize = new Vector2(width / 2, height / 2);
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xFF0000);
            graphics.drawRect(0, 0, Constants.CELL * width, Constants.CELL * height);
            graphics.endFill();
        }
		
		public function get center():Vector2 {
			return _center;
		}
		
		private function updateSpriteX(centerX:Number): void {
			super.x = (centerX - halfSize.x) * Constants.CELL;
		}
        
		private function updateSpriteY(centerY:Number): void {
			super.y = (centerY - halfSize.y) * Constants.CELL;
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
    
        public function Update(dt:Number) {
            motion.Set(velocity.x, velocity.y).MulD(dt);
            center.AddV(motion);
        }
		
		public override function set x(_x:Number):void {
			center.x = _x / Constants.CELL + halfSize.x;
		}
		
		public override function set y(_y:Number):void {
			center.y = _y / Constants.CELL + halfSize.y;
		}
    }

}