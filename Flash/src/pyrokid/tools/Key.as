package pyrokid.tools {
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    
    public class Key {
        public static var debug:Boolean = false;
        private static var keysDown:Array = [];
        
        // Feel free to add more
        public static var UP:int = 38;
        public static var DOWN:int = 40;
        public static var LEFT:int = 37;
        public static var RIGHT:int = 39;
        public static var SPACE:int = 32;
        public static var A:int = 65;
        public static var S:int = 83;
        public static var W:int = 87;
        public static var D:int = 68;
        
        public static function init(stage:Stage):void {
            for (var i:int = 0; i < 128; i++) {
                keysDown.push(false);
            }
            
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
        }
        
        public static function isDown(key:int):Boolean {
            if (key < 0 || key > keysDown.length)
                return false;
            return keysDown[key];
        }
        
        private static function keyDown(e:KeyboardEvent):void {
            if (debug) trace(e.keyCode);
            keysDown[e.keyCode] = true;
        }
        
        private static function keyUp(e:KeyboardEvent):void {
            keysDown[e.keyCode] = false;
        }
        
        public static function reset():void {
            for (var i:int = 0; i < 128; i++) {
                keysDown[i] = false;
            }
        }
    }
}