package pyrokid {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import ui.LevelsInfo;
    
    public class CaveBackground extends Sprite {
        
        private var isRock:Boolean = false;
                
        public function CaveBackground(levelNum:int, cellsWide:int, cellsTall:int) {
            var neededWidth = cellsWide * Constants.CELL + 640;
            var neededHeight = cellsTall * Constants.CELL + 480;
            
            var bg:Bitmap = getBackgroundBitmap(levelNum);
            for (var i = -bg.width; i < neededWidth; i += bg.width) {
                if (isRock) {
                    for (var j = -bg.height; j < neededHeight; j += bg.height) {
                        bg = getBackgroundBitmap(levelNum);
                        bg.x = i;
                        bg.y = j;
                        addChild(bg);
                    }
                } else {
                    bg = getBackgroundBitmap(levelNum);
                    bg.x = i;
                    addChild(bg);
                }
            }
        }
        
        private function getBackgroundBitmap(levelNum:int):Bitmap {
            var bg:Bitmap;
            var scale:Number = 1.05;
            if (LevelsInfo.currLevel == 1) {
                bg = new Embedded.TutorialBackground1() as Bitmap;
                bg.scaleY = scale;
            } else if (LevelsInfo.currLevel == 2) {
                bg = new Embedded.TutorialBackground2() as Bitmap;
                bg.scaleY = scale;
            } else if (LevelsInfo.currLevel == 3) {
                bg = new Embedded.TutorialBackground3() as Bitmap;
                bg.scaleY = scale;
            } else {
                bg = new Embedded.RockBMP() as Bitmap;
                bg.scaleX = bg.scaleY = .5;
                isRock = true;
            }
            return bg;
        }
    
    }

}