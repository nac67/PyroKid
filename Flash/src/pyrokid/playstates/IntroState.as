package pyrokid.playstates {
    import flash.display.Sprite;
    import pyrokid.tools.Key;
    import pyrokid.tools.Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class IntroState extends ACPlayState {
        private static const COUNTDOWN_TIMER:int = 120;
        
        private var countDown:int;
        
        override protected function onEntry(parent:StateList):void {
            countDown = COUNTDOWN_TIMER;
            
            // TODO: Use A Nicer Image
            
            var back:Sprite = new Sprite();
            back.graphics.beginFill(0xbbbbbb, 1.0);
            back.graphics.drawRect(0, 0, 800, 600);
            back.graphics.endFill();
            addChild(back);
        }
        override protected function onExit(parent:StateList):void {
            Utils.removeAllChildren(this);
        }
        
        override public function updateLogic(parent:StateList):void {
            countDown--;
            if (countDown <= 0 || Key.isDown(Key.SPACE))
                moveToState("Main Menu");
        }
        override public function updateVisuals(parent:StateList):void {
        }
    }

}