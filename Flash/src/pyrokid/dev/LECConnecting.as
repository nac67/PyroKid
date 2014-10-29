package pyrokid.dev {
	import flash.display.Sprite;
    import flash.events.Event;
    import pyrokid.Level;
	
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class LECConnecting extends ACLevelEditorController {
        
        public function LECConnecting(l:Level) {
            super(l);
			addEventListener(Event.ADDED_TO_STAGE, init);
            renderSelf();
        }
        
        private function renderSelf():void {
            
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, dispose);
        }
        private function dispose(e:Event = null):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        override public function hookLogic() {
        
        }
        override public function unhookLogic() {
            
        }
    }

}