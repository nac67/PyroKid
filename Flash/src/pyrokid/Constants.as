package pyrokid {
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    
    public class Constants {
        
		public static var WIDTH:int = 800;
		public static var HEIGHT:int = 600;
        public static var CELL:int = 50;
        
        // fire constants
        public static var SPREAD_RATE:int = 30;
        public static var QUICK_BURN_TIME:int = SPREAD_RATE;
        
        public static var LEFT_BTN:int = 65;
        public static var RIGHT_BTN:int = 68;
        public static var JUMP_BTN:int = 87;
        public static var FIRE_BTN:int = Key.SPACE;
        public static var AIM_UP_BTN:int = Key.DOWN;
        
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
		
		public static var CAMERA_LAG:Number = 0.08;
        public static var GRAVITY:Number = 9;
        public static var GRAVITY_VECTOR = new Vector2(0, GRAVITY);
        public static var SPIDER_SPEED:Number = 1.5*CELL;
        public static var DT:Number = 1 / 30.0;
		
		public static var EMPTY_TILE_CODE:int = 0;
		public static var WALL_TILE_CODE:int = 1;
        public static var OIL_TILE_CODE:int = 2;
        public static var WOOD_TILE_CODE:int = 3;
        public static var METAL_TILE_CODE:int = 4;
    
    }

}