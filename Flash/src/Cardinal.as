package {
	/**
     * 
     * @author Cristian Zaloj
     */
    public class Cardinal {
        /**
         * Negative X Direction = 0
         */
        public static var NX:int = 0;
        /**
         * Positive X Direction = 1
         */
        public static var PX:int = 1;
        /**
         * Negative Y Direction = 2
         */
        public static var NY:int = 2;
        /**
         * Positive Y Direction = 3
         */
        public static var PY:int = 3;
        
        public static var DIRECTIONS:Array = [NX, PX, NY, PY];
        
        public static function getOpposite(dir:int):int {
            switch (dir) {
                case NX: return PX;
                case PX: return NX;
                case NY: return PY;
                case PY: return NY;
            }
            throw new Error("not a real direction");
        }
        
        public static function getVector2i(dir:int):Vector2i {
            switch (dir) {
                case NX: return new Vector2i(-1, 0);
                case PX: return new Vector2i(1, 0);
                case NY: return new Vector2i(0, -1);
                case PY: return new Vector2i(0, 1);
            }
            throw new Error("not a real direction");
        }
        
    }

}