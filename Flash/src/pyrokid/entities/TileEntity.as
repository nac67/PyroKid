package pyrokid.entities {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
	import physics.*;
	import pyrokid.*;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
		private var color:uint;
		public var globalAnchor:Vector2;
		
		public var oldGlobalAnchor:Vector2;
        
        public var cellSprites:Array;
        
        protected var objectCode:int;
		
		private static var directNeighbors:Array = [
			new Vector2i(0, -1),
			new Vector2i(0, 1),
			new Vector2i(-1, 0),
			new Vector2i(1, 0)
		];
		
		public function TileEntity(x:int, y:int, objCode:int) {
            objectCode = objCode;
			this.color = 0x00FF00;
			super(1, 1);
			this.x = x;
			this.y = y;
			cells = [];
            cellSprites = [];
		}
		
		protected function getSpriteForCell(cell:Vector2i):DisplayObject {
            // TODO this shouldn't be here . . . this should be an abstract class
            // with an abstract method but flash sucks...
            trace("poop");
            return new Sprite();
		}
        
        private function isFlammable():Boolean {
            return objectCode != Constants.METAL_TILE_CODE && objectCode != Constants.WALL_TILE_CODE;
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
		
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                level.onFire.push(this);
            }
		}
        
        public function updateFire(level:Level, currentFrame:int):void {
            
        }
		
		
	}
	
}