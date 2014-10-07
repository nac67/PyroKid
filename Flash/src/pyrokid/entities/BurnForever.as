package pyrokid.entities {
	import flash.display.Sprite;
	import physics.Vector2i;
	import flash.display.DisplayObject;
	import pyrokid.Constants;
	
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
		
		public override function ignite(onFire:Array, ignitionFrame:int):void {
			for (var i:int = 0; i < cells.length; i++) {
				var child:Sprite = new Sprite();
				child.graphics.lineStyle(0x000000);
				child.graphics.beginFill(0xFF0088);
				child.graphics.drawRect(20, 20, 10, 10);
				child.graphics.endFill();
				child.x = (cells[i].x - Math.floor(globalAnchor.x)) * Constants.CELL;
				child.y = (cells[i].y - Math.floor(globalAnchor.y)) * Constants.CELL;
				addChild(child);
			}
			ignitionTime = ignitionFrame;
			onFire.push(this);
		}
		
	}
	
}