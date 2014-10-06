package pyrokid {
	import physics.PhysBox;
	import physics.Vector2i;
	
	public class MultiTileGameEntity {
		
		public var entities:Array;
		
		private var ignitionTime:int = -1;
		
		private static var directNeighbors:Array = [
			new Vector2i(0, -1),
			new Vector2i(0, 1),
			new Vector2i(-1, 0),
			new Vector2i(1, 0)
		];
		
		public function MultiTileGameEntity(entities:Array) {
			this.entities = entities;
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
			for (var i:int = 0; i < entities.length; i++) {
				var e:PhysBox = entities[i];
				for (var j:int = 0; j < directNeighbors.length; j++) {
					coors.push((new Vector2i(e.cellX, e.cellY)).AddV(directNeighbors[j]));
				}
			}
			return coors;
		}
		
		public function ignite(onFire:Array, ignitionFrame:int):void {
			for (var i:int = 0; i < entities.length; i++) {
				entities[i].graphics.lineStyle(0x000000);
				entities[i].graphics.beginFill(0xFF0088);
				entities[i].graphics.drawRect(20, 20, 10, 10);
				entities[i].graphics.endFill();
			}
			ignitionTime = ignitionFrame;
			onFire.push(this);
		}
		
		public function isOnFire():Boolean {
			return ignitionTime >= 0;
		}
		
	}
	
}