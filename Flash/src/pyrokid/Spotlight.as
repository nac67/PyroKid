package pyrokid {
    import flash.display.Sprite;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Spotlight extends Sprite {
        private var big:Number = 15;
        private var small:Number = 1;
        
        public var shrink:Boolean = false;
        
        public function Spotlight() {
            this.addChild(new Embedded.SpotlightSWF());
        }
        
        public function step():void {
            var size:Number = (shrink ? small : big);
            this.scaleX += (size - this.scaleX) / 5;
            this.scaleY = this.scaleX;
            this.visible = this.scaleX < big - 1;
        }
    
    }

}