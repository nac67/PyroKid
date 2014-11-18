package  {
    import flash.display.Sprite;
    import org.flixel.system.*;
    
    // IMPORTANT: DON'T IMPORT ANYTHING FROM PYROKID, OTHERWISE
    // IT BREAKS FOR SOME REASON! JUST DON'T IMPORT ANYTHING ACTUALLY
    
    public class Preloader extends FlxPreloader {
        private static var P_WIDTH:int = 300;
        private static var P_HEIGHT:int = 30;
        
        private var outline:Sprite;
        private var fill:Sprite;
        
        public function Preloader():void {
            className = "Main";
            super();
        }
        //
        //override protected function create():void {
            //_buffer = new Sprite();
            //addChild(_buffer);
            //
            //updateBar(0);
        //}
        //override protected function update(Percent:Number):void {
            //updateBar(Percent);
        //}
        //
        //private function updateBar(Percent:Number) {
            //var tlx:int = 800 / 2 - P_WIDTH / 2;
            //var tly:int = 600 / 2 - P_HEIGHT / 2;
            //
            //_buffer.graphics.clear();
            //_buffer.graphics.lineStyle(1, 0x000000);
            //_buffer.graphics.drawRect(tlx, tly, P_WIDTH, P_HEIGHT);
            //_buffer.graphics.lineStyle(null);
            //_buffer.graphics.beginFill(0x000000);
            //_buffer.graphics.drawRect(tlx, tly, P_WIDTH * Percent, P_HEIGHT);
            //_buffer.graphics.endFill();
        //}
    }

}