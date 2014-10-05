package physics {
	import flash.display.Sprite;
	import pyrokid.Constants;
	
	/* This class ensures that the physics engine is always in sync with
	 * the Sprites. Anything in the game that will be processed by the
	 * physics engine should extend this class. If an object in the game
	 * spans multiple tiles, it will contain a grouping of GameEntities
	 * because the physics engine handles only individual tiles. */
	public class GameEntity extends Sprite {
		private var _center:Vector2 = new Vector2();
        private var _halfSize:Vector2 = new Vector2();
		
		public function GameEntity(width:Number = 1, height:Number = 1, color:uint = 0xFF0000) {
			_center = new Vector2(0, 0, updateSpriteX, updateSpriteY);
			_halfSize = new Vector2(width / 2, height / 2);
            graphics.lineStyle(0x000000);
            graphics.beginFill(color);
            graphics.drawRect(0, 0, Constants.CELL * width, Constants.CELL * height);
            graphics.endFill();
        }
		
		/* These functions handle the conversion between physics engine coordinates
		 * and Sprite coordinates. The physics engine uses the center of an object
		 * and each tile is 1 unit wide, while the Sprites use the top left corner
		 * of an object for its position and tiles are Constants.CELL wide. */
		public override function set x(_x:Number):void {
			center.x = _x / Constants.CELL + halfSize.x;
		}
		public override function set y(_y:Number):void {
			center.y = _y / Constants.CELL + halfSize.y;
		}
		private function updateSpriteX(centerX:Number): void {
			super.x = (centerX - halfSize.x) * Constants.CELL;
		}
		private function updateSpriteY(centerY:Number): void {
			super.y = (centerY - halfSize.y) * Constants.CELL;
		}
		public function get center():Vector2 {
			return _center;
		}
		public function get halfSize():Vector2 {
			return _halfSize;
		}
		// End of conversion functions
		
        
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