package pyrokid.entities {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import physics.Vector2i;
	import pyrokid.Level;
	
	public class BurnQuickly extends TileEntity {
		
		public function BurnQuickly(x:int, y:int):void {
			super(x, y);
		}
		
		protected override function getChild(cell:Vector2i):DisplayObject {
			var child:Sprite = new Sprite();
			child.graphics.lineStyle(0x000000);
			child.graphics.beginFill(0x0000FF);
			child.graphics.drawRect(0, 0, w, h);
			child.graphics.endFill();
			return child;
		}
		
		public override function ignite(level:Level, onFire:Array, ignitionFrame:int):void {
			for (var i:int = 0; i < cells.length; i++) {
				level.destroyTilePosition(cells[i].x, cells[i].y);
			}
		}
		
	}
	
}