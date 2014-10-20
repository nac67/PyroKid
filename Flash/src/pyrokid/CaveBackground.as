package pyrokid {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    public class CaveBackground extends Sprite {
        
        private static var SIZE:int = 500;
        
        public function CaveBackground(cellsWide:int, cellsTall:int) {
            var neededWidth:int = cellsWide * Constants.CELL + 640;
            var neededHeight:int = cellsTall * Constants.CELL + 480;
            
            for (var i:int = -SIZE; i < neededWidth; i += SIZE) {
                for (var j:int = -SIZE; j < neededHeight; j += SIZE) {    
                    var bg:Bitmap = new Embedded.BGBMP() as Bitmap;
                    bg.x = i;
                    bg.y = j;
                    addChild(bg);
                }
            }
            
        }
    
    }

}