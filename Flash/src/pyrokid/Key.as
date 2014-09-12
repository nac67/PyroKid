package pyrokid {
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    
    public class Key {
        public static var debug:Boolean = false;
        private static var keysDown:Array = [];
        
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
    }
}