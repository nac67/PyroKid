package pyrokid.entities {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import physics.Vector2i;
	
	public class BurnQuickly extends TileEntity {
		
		public function BurnQuickly(x:int, y:int):void {
			super(x, y);
		}
		
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
			var child:Sprite = new Sprite();
			child.graphics.lineStyle(0x000000);
			child.graphics.beginFill(0x0000FF);
			child.graphics.drawRect(0, 0, w, h);
			child.graphics.endFill();
			return child;
		}
		
	}
	
}