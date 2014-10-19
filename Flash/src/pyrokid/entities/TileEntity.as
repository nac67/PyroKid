package pyrokid.entities {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
	import physics.*;
	import pyrokid.*;
    import pyrokid.tools.Utils;
	
	public class TileEntity extends GameEntity {
		
		public var cells:Array;
        
        // position, in tile coordinates, relative to the corner of the island.
        public var islandAnchor:Vector2;
        
        public var parentIsland:Island;
        
        public var cellSprites:Array;
        
        protected var objectCode:int;
		
		public function TileEntity(x:int, y:int, objCode:int) {
            objectCode = objCode;
			this.x = x;
			this.y = y;
			cells = [];
            cellSprites = [];
		}
        
        public function getGlobalAnchor():Vector2 {
            return parentIsland.globalAnchor.copy().AddV(islandAnchor);
        }
		
		protected function getSpriteForCell(cell:Vector2i):DisplayObject {
            trace("This is an \"Abstract Method\" and you should never see this printed out");
            return null;
		}
        
        private function isFlammable():Boolean {
            return objectCode != Constants.METAL_TILE_CODE && objectCode != Constants.WALL_TILE_CODE;
        }
		
		public function finalizeCells():void {
			for (var i:int = 0; i < cells.length; i++) {
				var child:DisplayObject = getSpriteForCell(cells[i]);
				child.x = cells[i].x * Constants.CELL;
				child.y = cells[i].y * Constants.CELL;
				addChild(child);
                cellSprites.push(child);
			}
		}
		
		// TODO optimize this. It should be calculated once, and it should not
		// do the same neighbor multiple times -- Aaron
        // TODO this should throw something if called when the tile entity is moving -- Aaron
		public function getNeighborCoordinates(grid:Array):Array {
			var coors:Array = [];
			for each (var cell:Vector2i in cells) {
                var globalAnchor:Vector2i = getGlobalAnchor().copyAsVec2i();
                Utils.getNeighborCoors(cell.x + globalAnchor.x, cell.y + globalAnchor.y, coors);
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