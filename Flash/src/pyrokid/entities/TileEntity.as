package pyrokid.entities {
	import flash.display.Sprite;
	import physics.PhysBox;
	import physics.Vector2;
	import physics.Vector2i;
	import pyrokid.Constants;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
		private var color:uint;
		public var globalAnchor:Vector2;
		
		private static var directNeighbors:Array = [
			new Vector2i(0, -1),
			new Vector2i(0, 1),
			new Vector2i(-1, 0),
			new Vector2i(1, 0)
		];
		
		public function TileEntity(x:int, y:int) {
			this.color = 0x00FF00;
			super(1, 1);
			this.x = x;
			this.y = y;
			cells = [];
		}
		
		public function finalizeCells():void {
            graphics.lineStyle(0x000000);
			graphics.beginFill(color);
			for (var i:int = 0; i < cells.length; i++) {
				graphics.drawRect(
					(cells[i].x - Math.floor(globalAnchor.x)) * Constants.CELL,
					(cells[i].y - Math.floor(globalAnchor.y)) * Constants.CELL,
					w,
					h
				);
			}
			graphics.endFill();
		}
		
		public function getNeighborCoordinates(grid:Array):Array {
			var coors:Array = [];
			for (var i:int = 0; i < cells.length; i++) {
				for (var j:int = 0; j < directNeighbors.length; j++) {
					var a:Vector2i = cells[i];
					var b:Vector2i = directNeighbors[j];
					coors.push(new Vector2i(a.x + b.x, a.y + b.y));
				}
			}
			return coors;
		}
		
		public override function ignite(onFire:Array, ignitionFrame:int):void {
			// TODO make it draw on the appropriate cell
			for (var i:int = 0; i < cells.length; i++) {
				graphics.lineStyle(0x000000);
				graphics.beginFill(0xFF0088);
				graphics.drawRect(20, 20, 10, 10);
				graphics.endFill();
			}
			ignitionTime = ignitionFrame;
			onFire.push(this);
		}
		
		
	}
	
}