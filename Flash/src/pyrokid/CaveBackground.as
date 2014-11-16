package pyrokid {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    public class CaveBackground extends Sprite {
        
        private static var SIZE:int = 200;
        
        public function CaveBackground(cellsWide:int, cellsTall:int) {
            var neededWidth = cellsWide * Constants.CELL + 640;
            var neededHeight = cellsTall * Constants.CELL + 480;
            //var neededWidth:int = cellsWide * Constants.CELL;
            //var neededHeight:int = cellsTall * Constants.CELL;
             
            for (var i = -SIZE; i < neededWidth; i += SIZE) {
                for (var j = -SIZE; j < neededHeight; j += SIZE) {    
            //for (var i:int = 0; i < neededWidth; i += SIZE - 1) {
                //for (var j:int = 0; j < neededHeight; j += SIZE - 1) {   
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