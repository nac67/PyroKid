package physics {
	import flash.display.Sprite;
    import flash.geom.Rectangle;
	import pyrokid.Constants;

    public class DynamicEntity extends GameEntity {
        
        public var velocity:Vector2 = new Vector2();
        public var motion:Vector2 = new Vector2();
		
        //width and height are a percentage of a tile
		public function DynamicEntity(width:Number, height:Number, color:uint = 0xFF0000) {
			super(width, height, color);
        }

        public function Update(dt:Number) {
            motion.Set(velocity.x, velocity.y).MulD(dt);
            center.AddV(motion);
        }
    }

}