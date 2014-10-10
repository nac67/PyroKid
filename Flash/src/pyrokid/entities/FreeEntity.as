package pyrokid.entities {
	import flash.display.Sprite;
    import physics.*;
	
	public class FreeEntity extends GameEntity {
        
        public var isGrounded:Boolean = false;
        public var touchLeft:Boolean = false;
        public var touchRight:Boolean = false;
        public var touchTop:Boolean = false;
        
        public function resolveCollision(r:PhysRectangle, a:CollisionAccumulator, o:PhysCallbackOptions):Boolean {
            if (a.accumNY > 0) isGrounded = true;
            if (a.accumPY > 0) touchTop = true;
            if (a.accumNX > 0) touchRight = true;
            if (a.accumPX > 0) touchLeft = true;
            return true;
        }
		
		public function FreeEntity(width:Number = 1, height:Number = 1, color:uint=uint.MAX_VALUE) {
			super(width, height);
            
            if(color != uint.MAX_VALUE){
			    graphics.lineStyle(0x000000);
			    graphics.beginFill(color);
			    graphics.drawRect(0, 0, w, h);
			    graphics.endFill();
            }
		}
	}
	
}