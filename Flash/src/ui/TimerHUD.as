package ui {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import pyrokid.Constants;
    public class TimerHUD extends Sprite {
        private var tf:TextField;
        private var format:TextFormat;
        
        public function TimerHUD() {
            x = Constants.WIDTH - 45;
            y = 10;
            
            tf = new TextField();
            tf.selectable = false;
            
            format = new TextFormat();
			format.size = 20;
			format.font = "Impact";
			format.color = 0xFFFFFF;
            addChild(tf);
        }
        
        public function set time (val:int) {
            tf.text = Utils.frameCountToTimeDisplay(val);
            tf.setTextFormat(format);
        }
        
    }

}