package pyrokid.entities {
	import flash.display.Sprite;
	import physics.PhysBox;
	import physics.Vector2i;
	import pyrokid.Constants;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
		
		private static var directNeighbors:Array = [
			new Vector2i(0, -1),
			new Vector2i(0, 1),
			new Vector2i(-1, 0),
			new Vector2i(1, 0)
		];
		
		public function TileEntity(x:int, y:int) {
			super(1, 1, 0x00FF00);
			this.x = x;
			this.y = y;
			cells = [];
            /*graphics.lineStyle(0x000000);
            graphics.beginFill(0x00FF00);
            graphics.drawRect(0, 0, Constants.CELL, Constants.CELL);
            graphics.endFill();*/
			/*entities = [];
			for (var i:int = 0; i < cells.length; i++) {
				var entity:PhysBox = new PhysBox(true, 0xCCCCFF);
				entity.x = cells[i].x * Constants.CELL;
				entity.y = cells[i].y * Constants.CELL;
				entities.push(entity);
			}*/
		}
		
		public function getNeighborCoordinates(grid:Array):Array {
			var coors:Array = [];
			for (var i:int = 0; i < cells.length; i++) {
				for (var j:int = 0; j < directNeighbors.length; j++) {
					coors.push(cells[i].AddV(directNeighbors[j]));
				}
			}
			return coors;
		}
		
		public override function ignite(onFire:Array, ignitionFrame:int):void {
			for (var i:int = 0; i < cells.length; i++) {
				cells[i].graphics.lineStyle(0x000000);
				cells[i].graphics.beginFill(0xFF0088);
				cells[i].graphics.drawRect(20, 20, 10, 10);
				cells[i].graphics.endFill();
			}
			ignitionTime = ignitionFrame;
			onFire.push(this);
		}
		
		
	}
	
}