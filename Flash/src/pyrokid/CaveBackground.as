package pyrokid {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    public class CaveBackground extends Sprite {
        
        private static var SIZE:int = 200;
        
        public function CaveBackground(cellsWide:int, cellsTall:int) {
            var neededWidth = cellsWide * Constants.CELL + 640;
            var neededHeight = cellsTall * Constants.CELL + 480;
            
            for (var i = -SIZE; i < neededWidth; i += SIZE) {
                for (var j = -SIZE; j < neededHeight; j += SIZE) {    
                    var bg:Bitmap = new Embedded.RockBMP() as Bitmap;
                    bg.scaleX = bg.scaleY = .5;
                    bg.x = i;
                    bg.y = j;
                    addChild(bg);
                }
            }
            
        }
    
    }

}