package pyrokid.tools {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
	import physics.PhysBox;
	import physics.Vector2;
	import physics.Vector2i;
	import pyrokid.entities.*;
    import pyrokid.*;
    
    public class Utils {
        
		private static var directNeighbors:Array = [
			new Vector2i(0, -1),
			new Vector2i(0, 1),
			new Vector2i(-1, 0),
			new Vector2i(1, 0)
		];
        
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
            while (obj.numChildren > 0) {
                obj.removeChildAt(0);
            }
        }
        
        /** Performs BFS on array, starting at start. It considers an element in the array a
         *  neighbor if it is adjacent in one of the four cardinal directions and isNeighbor
         *  returns true on that coordinate. processNode is called on each coordinate exactly
         *  once, and it returns true iff the BFS should terminate after that node.
         *  @param isNeighbor function(coor:Vector2i):Boolean
         *  @param processNode function(coor:Vector2i):Boolean */
        public static function BFS(array:Array, start:Vector2i, isNeighbor:Function, processNode:Function):void {
            var queue:Array = [];
            var visited:Dictionary = new Dictionary();
            visited[start.toString()] = true;
            queue.push(start);
            while (queue.length > 0) {
                var coor:Vector2i = queue.shift();
                var finishedSearch:Boolean = processNode(coor);
                if (finishedSearch) {
                    return;
                }
                
                var neighbors:Array = getNeighborCoors(coor.x, coor.y);
                neighbors = neighbors.filter(function(nei) {
                    return inBounds(array, nei.x, nei.y) && isNeighbor(nei);
                });
                for each (var neighbor:Vector2i in neighbors) {
                    if (!visited[neighbor.toString()]) {
                        queue.push(neighbor);
                        visited[neighbor.toString()] = true;
                    }
                }
            }
        }
        
        /* Prints a 2D array in a viewer-friendly way, making sure each element in a row
         * is spaced apart by at least spacing.*/
        public static function print2DArr(array:Array, spacing:int = 3):void {
            trace("printing array");
            for each (var row:Array in array) {
                var rowStr:String = "";
                for (var j:int = 0; j < row.length; j++) {
                    var str:String = row[j] != undefined ? row[j].toString() : "NA";
                    var padding = Math.max(spacing - str.length, 0);
                    rowStr += str;
                    for (var i:int = 0; i < padding; i++) {
                        rowStr += " ";
                    }
                    rowStr += ",";
                }
                trace(rowStr);
            }
        }
        
        /* Applies func to each element in the 2D array. func should have
         * the following signature: function(x:int, y:int, element):void */
        public static function foreach(array:Array, func:Function):void {
            for (var y:int = 0; y < array.length; y++) {
                for (var x:int = 0; x < array[0].length; x++) {
                    func(x, y, array[y][x]);
                }
            }
        }
        
        
        /* Returns an array of the neighboring values to (x, y) in the given 2D array. */
        public static function getNeighbors(array:Array, x:int, y:int):Array {
            return filterNull(getNeighborCoors(x, y).map(function(coor:Vector2i) {
                return index(array, coor.x, coor.y);
            }));
        }
        
        /* Returns an array of the neighboring coordinates to (x, y).
         * coors, if provided, is an existing array of coordinates onto
         * which the neighboring coordinates are appended. */
        public static function getNeighborCoors(x:int, y:int, coors:Array = null):Array {
			if (coors == null) {
                coors = [];
            }
            for each (var direction:Vector2i in directNeighbors) {
                coors.push(new Vector2i(x + direction.x, y + direction.y));
            }
			return coors;
        }
        
        /* Returns a new 2D array with dimensions width and height.
         * The height is the first dimension, width the second. */
        public static function newArray(width:int, height:int):Array {
            var array:Array = [];
            for (var y:int = 0; y < height; y++) {
                array.push(new Array(width));
            }
            return array;
        }
        
        /* Returns true iff (x, y) is a valid index in the 2D array. */
		public static function inBounds(array:Array, x:int, y:int):Boolean {
			return y >= 0 && x >= 0 && y < array.length && x < array[0].length;
		}
		
        /* Returns the item at (x, y) in the 2D array if it exists,
         * or null if (x, y) is out of bounds. */
        public static function index(array:Array, x:int, y:int) {
            if (inBounds(array, x, y)) {
                return array[y][x];
            }
            return null;
        }
        
        /* Returns the same array with all null values filtered out. */
        public static function filterNull(array:Array):Array {
            return array.filter(function(o) { return o != null; });
        }
        
        /* Moves obj by distance in the direction that obj is facing. You can offset the direction
         * rotation by offset degrees */
        public static function moveInDirFacing(obj:DisplayObject, distance:int, offset:Number = 0) {
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