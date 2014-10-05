package physics {
	import flash.display.Sprite;
    import flash.geom.Rectangle;
	import pyrokid.Constants;

    public class DynamicEntity extends GameEntity {
        
        public var velocity:Vector2 = new Vector2();
        public var motion:Vector2 = new Vector2();
		
		public function DynamicEntity(width:Number, height:Number) {
			super(width, height);
        }

        public function Update(dt:Number) {
            motion.Set(velocity.x, velocity.y).MulD(dt);
            center.AddV(motion);
        }
    }

}