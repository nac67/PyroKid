package pyrokid.graphics {
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class TileTexture {
        public static const TYPE_UNKNOWN:int = 0;
        public static const TYPE_CONNECTED:int = 1;
        public static const TYPE_SINGLE:int = 2;
        
        public var id:int;
        public var type:int;
        
        public function TileTexture(_id:int, _type:int = TYPE_UNKNOWN) {
            id = _id;
            type = _type;
        }
        
    }

}