package pyrokid.entities {
	import flash.display.Sprite;
	
	public class FreeEntity extends GameEntity {
		
		public function FreeEntity(width:Number = 1, height:Number = 1) {
			super(width, height);
			graphics.lineStyle(0x000000);
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
	}
	
}