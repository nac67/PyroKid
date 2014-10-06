package pyrokid {
    import flash.display.Sprite;
	import physics.PhysBox;
	import physics.Vector2;
	import physics.Vector2i;
	import pyrokid.entities.*;
    
    public class Utils {
        
        public static function removeAllChildren(obj:Sprite):void {
            while (obj.numChildren > 0) {
                obj.removeChildAt(0);
            }
        }
		
		public static function getCellXY(obj:GameEntity):Vector2i {
			return new Vector2i(pixelToCell(obj.x), pixelToCell(obj.y));
		}
		
		public static function getCellXYCenter(spritePosition:Vector2i):Vector2 {
			return new Vector2(
				pixelToCellExact(spritePosition.x) + 0.5,
				pixelToCellExact(spritePosition.y) + 0.5
			);
		}
		public static function getSpritePosition(cellXYCenter:Vector2):Vector2i {
			return new Vector2i(
				cellToPixel(cellXYCenter.x - 0.5),
				cellToPixel(cellXYCenter.y - 0.5)
			);
		}
		public static function pixelToCellExact(pixel:int):Number {
			return pixel / Constants.CELL;
		}
		
		public static function physicsEngineCenterToPixelTopLeft(center:Number):int {
			return (center - 0.5) * Constants.CELL;
		}
		
		public static function cellToPixel(cellCoor:int):int {
			return cellCoor * Constants.CELL;
		}
		
		public static function pixelToCell(pixelCoor:int):int {
			return Math.floor(pixelCoor / Constants.CELL);
		}
		
		public static function setCell(obj:GameEntity, cell:Vector2i):void {
			obj.x = cellToPixel(cell.x);
			obj.y = cellToPixel(cell.y);
		}
    
    }

}