package pyrokid {
    import flash.display.Bitmap;
    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;
    import flash.media.SoundMixer;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    
    public class Constants {
        // LOGGING
        public static var TEAM_ID:int = 100;
        public static var VERSION_ID:int = 2;
        public static var DO_LOGGING:Boolean = false;
        
        public static var ERROR_MESSAGE:String = "STOP. This should never happen: ";
        
        public static var DEBUG:Boolean = false;
        public static var DEBUG_DRAW:Boolean = false;
        public static var LEVEL_EDITOR_ENABLED:Boolean = true;
        public static var GOD_MODE:Boolean = false;
		public static var ALL_LEVELS_UNLOCKED:Boolean = false;
		public static var LEVEL_UNLOCK_NEXT_PAGE_PROPORTION:Number = (7 / 9);
		public static var START_FRESH_GAME:Boolean = false;
        
		public static var WIDTH:int = 800;
		public static var HEIGHT:int = 600;
        public static var CELL:int = 50;
        
        public static var FALL_TO_DEATH_HEIGHT:int = 0;
        
        public static var DEATH_CLIP_TYPE_SMOOSH = 0;
        public static var DEATH_CLIP_TYPE_FIRE = 1;
        
        public static var FADE_TIME:int = 60;
        public static var GAME_NOT_OVER:int = 0;
        public static var GAME_OVER_FADING:int = 1;
        public static var GAME_OVER_COMPLETE:int = 2;
        
        public static var DEATH_BY_ENEMY:String = "enemy";
        public static var DEATH_BY_FIRE:String = "fire";
        public static var DEATH_BY_SMOOSH:String = "smoosh";
        public static var DEATH_BY_FALLING:String = "fall";
        public static var DEATH_BY_RESTART:String = "leave";
        
        // level editor constants
        public static var EDITOR_OBJECT_MODE:int = 0;
        public static var EDITOR_CLUMP_MODE:int = 1;
        public static var EDITOR_CONNECTOR_MODE:int = 2;
        public static var EDITOR_PROPERTIES_MODE:int = 3;
        
        // fire constants
        public static var SPREAD_RATE:int = 30;
        public static var QUICK_BURN_TIME:int = SPREAD_RATE;
        public static var SPREAD_WHILE_FALLING:Boolean = false;
        
        public static var LEFT_BTN:int;
        public static var RIGHT_BTN:int;
        public static var JUMP_BTN:int;
        public static var AIM_UP_BTN:int;
        public static var AIM_DOWN_BTN:int;
        public static var AIM_LEFT_BTN:int;
        public static var AIM_RIGHT_BTN:int;
        
        public static var ALLOW_JUMP_HOLD:Boolean = false;
        public static var PLAYER_MOVE_ZOOM:Boolean = false;
        
        
        // fake enums
        public static var DIR_UP:int = 101;
        public static var DIR_DOWN:int = 102;
        public static var DIR_LEFT:int = 103;
        public static var DIR_RIGHT:int = 104;
        
        public static var FBALL_SPEED:int = 12; //pixels per frame
        public static var FIREBALL_CHARGE:int = 60; //maximum charge
        public static var MIN_BALL_RANGE:Number = .5; //tiles travelled with no charge
        public static var MAX_BALL_RANGE:Number = 5.5; //tiles travelled with max charge
        public static var FIREBALL_COOLDOWN:int = 30; //frames to wait between shots
        
        public static var WATERBALL_COOLDOWN:int = 60;
        public static var WATERBALL_SPEED:int = 4;
        public static var WATERBALL_RANGE:int = 7.5;
		
		public static var CAMERA_LAG:Number = 0.08;
        public static var GRAVITY:Number = 8;
        public static var GRAVITY_ENT:Number = 9;
        public static var GRAVITY_VECTOR = new Vector2(0, GRAVITY);
        public static var GRAVITY_VECTOR_ENT = new Vector2(0, GRAVITY_ENT);
        public static var SPIDER_SPEED:Number = 1.5*CELL;
        public static var DT:Number = 1 / 30.0;
        public static var PLAYER_XSPEED:int = 2 * CELL;
        public static var PLAYER_JUMP_SPEED:int = 6.3 * CELL;
        public static var PLAYER_JUMP_FALLING_MULTIPLIER:Number = 1 / 450.0;
        public static var PLAYER_CEILING_HANG_TIME:int = 5;
		
        // TileEntity codes. Must be ints.
		public static var EMPTY_TILE_CODE:int = 0;
		public static var WALL_TILE_CODE:int = 1;
        public static var OIL_TILE_CODE:int = 2;
        public static var WOOD_TILE_CODE:int = 3;
        public static var METAL_TILE_CODE:int = 4;
        
        // Edge codes
        public static var CONNECTOR_CODE:int = 0;
        public static var METAL_EDGE_CODE:int = 1;
        
        // FreeEntity codes. Must be Strings.
        public static var SPIDER_CODE:String = "spider";
        public static var SPIDER_ARMOR_CODE:String = "spider_armor";
        public static var IMMUNE_CODE:String = "immune";
        public static var BAT_CODE:String = "bat";
        public static var BOMB_EXIT_CODE:String = "exit";
        public static var HOLE_EXIT_CODE:String = "hole_exit";
        
        public static var GROUNDED_TYPES:Array = [WALL_TILE_CODE];
        public static var SINGLE_TILE_TYPES:Array = [];
        
        public static function GET_TILE_SET(tileCode:int):Bitmap {
            switch (tileCode) {
                case WALL_TILE_CODE: return new Embedded.DirtMergeBMP() as Bitmap;
                case WOOD_TILE_CODE: return new Embedded.WoodMergeBMP() as Bitmap;
                case METAL_TILE_CODE: return new Embedded.MetalMergeBMP() as Bitmap;
                case OIL_TILE_CODE: return new Embedded.LavaMergeBMP() as Bitmap;
            }
            return null;
        }
        
        public static function switchControlScheme(scheme:int):void {
            if (scheme == 0) {
                LEFT_BTN = 65;
                RIGHT_BTN = 68;
                JUMP_BTN = 87;
                AIM_UP_BTN = Key.UP;
                AIM_DOWN_BTN = Key.DOWN;
                AIM_LEFT_BTN = Key.LEFT;
                AIM_RIGHT_BTN = Key.RIGHT;
            } else if (scheme == 1) {
                LEFT_BTN = Key.LEFT;
                RIGHT_BTN = Key.RIGHT;
                JUMP_BTN = Key.UP;
                AIM_UP_BTN = 87;
                AIM_DOWN_BTN = 83;
                AIM_LEFT_BTN = 65;
                AIM_RIGHT_BTN = 68;
            }
        }
        
        
        // Sound control
        public static var SOUND_ON:Boolean = true;
        public static var MUSIC_STARTS_ON:Boolean = false;
        
        public static var _MUSIC_ON:Boolean = false;
        
        public static function get MUSIC_ON():Boolean {
            return _MUSIC_ON;
        }
        
        public static function set MUSIC_ON(on:Boolean):void {
            if (on) {
                Embedded.musicSound.play(0, 999999);
            } else {
                SoundMixer.stopAll();
            }
        }
    
    }

}