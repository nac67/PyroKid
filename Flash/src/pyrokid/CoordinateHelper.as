package pyrokid{
    public class CoordinateHelper {
        public static function realToCell (real:Number):Number {
            return Math.floor(real/50);
        }
    }
}