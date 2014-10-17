package pyrokid {
    import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import pyrokid.playstates.GamingState;
    import pyrokid.playstates.IntroState;
    import pyrokid.playstates.LevelEditorState;
    import pyrokid.playstates.MainMenuState;
    import pyrokid.playstates.StateList;
	import ui.*;
    import physics.*;
    import pyrokid.entities.*;
    import pyrokid.tools.*;
    
    public class Main extends Sprite {
		public static var MainStage:Stage;

		private var states:StateList;
        
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			
            // Do We Really Need This?
            MainStage = stage;

            // Input Initialization
            Key.init(stage);
            Constants.switchControlScheme(0);
            
            // Clean Way Of Managing States
            states = new StateList(this);
            states.addState("Intro", new IntroState());
            states.addState("Main Menu", new MainMenuState());
            states.addState("Gaming", new GamingState());
            states.addState("Editor", new LevelEditorState());
            states.start("Intro");
        }
    }
    
}