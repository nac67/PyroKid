package pyrokid {
    import flash.media.Sound;
    import flash.utils.Dictionary;
    
    public class SoundManager {
        
        private static var MAX_OVERLAP:int = 2;
        
        public static var currentlyStarted:Dictionary = new Dictionary();
        
        /**
         * Call this at the end of the update loop
         */
        public static function endFrame() {
            for (var k:Object in currentlyStarted) {
                currentlyStarted[k] = 0;
            }
        }
        
        public static function playSound(sound:Sound) {
            if (GameSettings.soundOn) {
                if (getCount(sound) < MAX_OVERLAP) {
                    sound.play();
                    increment(sound);
                }
            }
        }
        
        private static function increment(key:Object) {
            if (currentlyStarted[key] == undefined) {
                currentlyStarted[key] = 1;
            } else {
                currentlyStarted[key] = currentlyStarted[key] + 1;
            }
        }
        
        private static function getCount(key:Object) {
            if (currentlyStarted[key] == undefined) {
                return 0;
            } else {
                return currentlyStarted[key];
            }
        }
    
    }

}