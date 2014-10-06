package pyrokid {
	import physics.PhysBox;
	
	public class MultiTileGameEntity {
		
		public var entities:Array;
		
		public function MultiTileGameEntity(cells:Array) {
			entities = [];
			for (var i:int = 0; i < cells.length; i++) {
				var entity:PhysBox = new PhysBox(true, 0xCCCCFF);
				entity.x = cells[i].x * Constants.CELL;
				entity.y = cells[i].y * Constants.CELL;
				entities.push(entity);
			}
		}
		
	}
	
}