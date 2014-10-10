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
        
		public static function inBounds(array:Array, x:int, y:int):Boolean {
			return y >= 0 && x >= 0 && y < array.length && x < array[0].length;
		}
		
        public static function index(array:Array, x:int, y:int) {
            if (inBounds(array, x, y)) {
                return array[y][x];
            }
            return null;
        }
        
        public static function filterNull(array:Array):Array {
            return array.filter(function(o) { return o != null; });
        }
		
		// -------------------- Coordinate Conversion Functions --------------------- //
		public static function cellToPixel(cellCoor:int):int {
			return cellCoor * Constants.CELL;
		}
    
    }

}