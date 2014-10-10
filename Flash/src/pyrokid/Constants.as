package pyrokid {
    import physics.Vector2;
    
    public class Constants {
        
		public static var WIDTH:int = 800;
		public static var HEIGHT:int = 600;
        public static var CELL:int = 50;
        
        public static var LEFT_BTN:int = Key.LEFT;
        public static var RIGHT_BTN:int = Key.RIGHT;
        public static var JUMP_BTN:int = Key.UP;
        public static var FIRE_BTN:int = Key.SPACE;
        
        // fake enums
        public static var DIR_UP:int = 101;
        public static var DIR_DOWN:int = 102;
        public static var DIR_LEFT:int = 103;
        public static var DIR_RIGHT:int = 104;
        
        public static var FBALL_SPEED:int = 10; //pixels per frame
        public static var FIREBALL_CHARGE:int = 60; //maximum charge
        public static var MIN_BALL_RANGE:Number = .5; //tiles travelled with no charge
        public static var MAX_BALL_RANGE:Number = 5.5; //tiles travelled with max charge
        public static var FIREBALL_COOLDOWN:int = 30; //frames to wait between shots
		
		public static var CAMERA_LAG:Number = 0.92;
        public static var GRAVITY:Number = 9;
        public static var GRAVITY_VECTOR = new Vector2(0, GRAVITY);
        public static var SPIDER_SPEED:Number = 1.5*CELL;
        public static var DT:Number = 1 / 30.0;
		
		public static var EMPTY_TILE_CODE:int = 0;
		public static var WALL_TILE_CODE:int = 1;
    
    }

}