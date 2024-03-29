package  {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
	import physics.PhysBox;
	import physics.Vector2;
	import physics.Vector2i;
	import pyrokid.entities.*;
    import pyrokid.*;
    
    public class Utils {
        /**
         * Create A Multidimensional Array
         * @param dimension Integer Array Specifying Size Of Each Dimension
         */
        public static function createMultiArray(dimensions:Array):Array {
            // This Is A Bad Argument
            if (dimensions == null || dimensions.length < 1) return null;
            return createMultiArrayRec(0, dimensions);
        }
        private static function createMultiArrayRec(i:int, dimensions:Array):Array {
            var a:Array = new Array(dimensions[i]);
            if (i + 1 < dimensions.length) {
                i++;
                for (var j:int = 0; j < a.length; j++) {
                    a[j] = createMultiArrayRec(i, dimensions);
                }
            }
            return a;
        }
        
        /**
         * Converts a coordinate from pixel-space to cell space,
         * truncating as necessary
         * @param real
         * @return
         */
        public static function realToCell (real:Number):Number {
            return Math.floor(real/Constants.CELL);
        }
        
        /**
         * Given a y-coordinate for the cell, this returns the pixel
         * coordinate of the top of the cell. This can also be used to
         * find the left edge of the cell given an x-coordinate
         * @param cell Coordinate
         * @return Pixel-space coordinate
         */
        public static function topOfCell (cell:int):Number {
            return cell * Constants.CELL;
        }
        
        /**
         * Given a y-coordinate for the cell, this returns the pixel
         * coordinate of the bottom of the cell. This can also be used to
         * find the right edge of the cell given an x-coordinate
         * @param cell Coordinate
         * @return Pixel-space coordinate
         */
        public static function bottomOfCell (cell:int):Number {
            return (cell+1) * Constants.CELL;
        }
        
        public static function lerp(a:Number, b:Number, r:Number):Number {
            return a + r * (b - a);
        }
        
        public static function removeAllChildren(obj:Sprite):void {
            for (var i:int = obj.numChildren-1; i >= 0; i--) {
               obj.removeChildAt(i);
            }
        }

        public static function filterNull(array:Array):Array {
            return array.filter(function(o:Object, i:int, a:Array):Boolean { return o != null; } );
        }
        
        
        /* Moves obj by distance in the direction that obj is facing. You can offset the direction
         * rotation by offset degrees */
        public static function moveInDirFacing(obj:DisplayObject, distance:int, offset:Number = 0):void {
            obj.x += distance * Math.cos((obj.rotation + offset) * (Math.PI / 180));
            obj.y += distance * Math.sin((obj.rotation + offset) * (Math.PI / 180));
        }
        
        
        public static function getXYMultipliers (direction:int):Vector2i {
            if (direction == Constants.DIR_LEFT) {
                return new Vector2i(-1, 0);
            } else if (direction == Constants.DIR_RIGHT) {
                return new Vector2i(1, 0);
            } else if (direction == Constants.DIR_UP) {
                return new Vector2i(0, -1);
            } else if (direction == Constants.DIR_DOWN) {
                return new Vector2i(0, 1);
            } else {
                return new Vector2i(0, 0);
            }
        }
		
		// -------------------- Coordinate Conversion Functions --------------------- //
		public static function cellToPixel(cellCoor:int):int {
			return cellCoor * Constants.CELL;
		}
    
    }

}