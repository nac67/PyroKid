package pyrokid.entities {
	import flash.display.Sprite;
	import physics.Vector2i;
	import flash.display.DisplayObject;
	
	public class BurnForever extends TileEntity {
		
		public function BurnForever(x:int, y:int):void {
			super(x, y);
		}
		
		protected override function getChild(cell:Vector2i):DisplayObject {
			var child:Sprite = new Sprite();
			child.graphics.lineStyle(0x000000);
			child.graphics.beginFill(0x00FF00);
			child.graphics.drawRect(0, 0, w, h);
			child.graphics.endFill();
			return child;
		}
		
	}
	
}