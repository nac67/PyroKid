package pyrokid {
    import flash.display.Sprite;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Utils {
        
        public static function removeAllChildren(obj:Sprite):void {
            while (obj.numChildren > 0) {
                obj.removeChildAt(0);
            }
        }
    
    }

}