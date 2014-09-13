package pyrokid{
    public class CoordinateHelper {
        /**
         * Converts a coordinate from pixel-space to cell space,
         * truncating as necessary
         * @param real
         * @return
         */
        public static function realToCell (real:Number):Number {
            return Math.floor(real/50);
        }
        
        /**
         * Given a y-coordinate for the cell, this returns the pixel
         * coordinate of the top of the cell. This can also be used to
         * find the left edge of the cell given an x-coordinate
         * @param cell Coordinate
         * @return Pixel-space coordinate
         */
        public static function topOfCell (cell:int):Number {
            return cell * 50 - 50;
        }
        
        /**
         * Given a y-coordinate for the cell, this returns the pixel
         * coordinate of the bottom of the cell. This can also be used to
         * find the right edge of the cell given an x-coordinate
         * @param cell Coordinate
         * @return Pixel-space coordinate
         */
        public static function bottomOfCell (cell:int):Number {
            return cell * 50;
        }
    }
}