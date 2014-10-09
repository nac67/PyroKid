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
		
		
		// -------------------- Coordinate Conversion Functions --------------------- //
		public static function cellToPixel(cellCoor:int):int {
			return cellCoor * Constants.CELL;
		}
    
    }

}