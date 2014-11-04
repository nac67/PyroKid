package pyrokid {
    import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import pyrokid.tools.LogMaster;
	import ui.playstates.StateController;
	import ui.*;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.Key;
    import pyrokid.dev.LevelEditor;
    
    public class Main extends Sprite {
		
		public static var MainStage:Stage;
        public static var log:LogMaster;
		
		private var curr_state:int;        
		
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            // entry point
            log = new LogMaster();
            
			MainStage = stage;
            Key.init(stage);
            Constants.switchControlScheme(0);
            			
			Utils.loadSavedData();
			
			addChild(StateController.display);
			StateController.goToMainMenu();
        }
    }

}