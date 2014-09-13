package pyrokid{
    public class CoordinateHelper {
        public static function realToCell (real:Number):Number {
            return Math.floor(real/50);
        }
        
        public static function topOfCell (cell:int):Number {
            return cell * 50 - 50;
        }
        
        public static function bottomOfCell (cell:int):Number {
            return cell * 50;
        }
    }
}