package pyrokid.graphics {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    
    public class Filmstrip extends Sprite {
        
        public static var allStrips:Array = [];
        
        private var crop:Rectangle;
        private var frameNumber:int;
        private var image:Bitmap;
        private var originX:int;
        private var originY:int;
        private var imageHeight:int;
        private var imageWidth:int;
        private var imagesInRow:int;
        private var numberOfImages:int;
        
        private var drawnObject:Bitmap;
        
        public function Filmstrip(image:Bitmap, originX:int, originY:int, imageWidth:int, imageHeight:int, imagesInRow:int, numberOfImages:int) {
            crop = new Rectangle(0, 0, imageWidth, imageHeight);
            
            if (numberOfImages > 1) {
                frameNumber = 0;
                this.image = image;
                this.originX = originX;
                this.originY = originY;
                this.imageWidth = imageWidth;
                this.imageHeight = imageHeight;
                this.imagesInRow = imagesInRow;
                this.numberOfImages = numberOfImages;
                
                drawnObject = new Bitmap();
                drawnObject.x = -originX;
                drawnObject.y = -originY;
                drawnObject.bitmapData =  new BitmapData(imageWidth, imageHeight);
                addChild(drawnObject);
                
                render();
                
                addEventListener(Event.ADDED_TO_STAGE, attach);
                addEventListener(Event.REMOVED_FROM_STAGE, detach);
            } else {
                addChild(image);
                image.x = -originX;
                image.y = -originY;
            }
        }
        
        public function nextFrame() {
            frameNumber = (frameNumber + 1) % numberOfImages;
            render();            
        }
        
        private function render() {
            var translation:Matrix = new Matrix();
            var tx = -(frameNumber % imagesInRow) * imageWidth;
            var ty = -(Math.floor(frameNumber / imagesInRow)) * imageHeight;
            translation.translate(tx, ty);
            
            drawnObject.bitmapData.fillRect(new Rectangle(0, 0, imageWidth, imageHeight), 0x00FFFFFF);
            drawnObject.bitmapData.draw(image, translation, null, null, crop);
        }
        
        private function attach(event) {
            allStrips.push(this);
        }
        
        private function detach(event) {
            allStrips.splice(allStrips.indexOf(this), 1);
        }
        
        public static function update() {
            for (var i = 0; i < allStrips.length; i++) {
                allStrips[i].nextFrame();
            }
        }
    
    }

}