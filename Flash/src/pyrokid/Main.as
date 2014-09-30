package pyrokid {
    import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Main extends Sprite {
		
		public static var MainStage:Stage;
        
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
			MainStage = stage;
            Key.init(stage);
			addChild(new GameController());
        }
		
    }

}