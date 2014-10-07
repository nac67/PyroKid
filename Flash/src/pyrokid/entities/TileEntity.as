package pyrokid.entities {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import physics.PhysBox;
	import physics.Vector2;
	import physics.Vector2i;
	import pyrokid.Constants;
	import pyrokid.Embedded;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
		private var color:uint;
		public var globalAnchor:Vector2;
        
        public var cellSprites:Array;
		
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
            cellSprites = [];
		}
		
		protected function getSpriteForCell(cell:Vector2i):DisplayObject {
			return new Embedded.DirtBMP();
		}
		
		public function finalizeCells():void {
			for (var i:int = 0; i < cells.length; i++) {
				var child:DisplayObject = getSpriteForCell(cells[i]);
				child.x = (cells[i].x - Math.floor(globalAnchor.x)) * Constants.CELL;
				child.y = (cells[i].y - Math.floor(globalAnchor.y)) * Constants.CELL;
				addChild(child);
                cellSprites.push(child);
			}
		}
		
		// TODO optimize this. It should be calculated once, and it should not
		// do the same neighbor multiple times
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
		
		public override function ignite(onFire:Array, ignitionFrame:int, harmfulObjects:Array):void {
		}
		
		
	}
	
}