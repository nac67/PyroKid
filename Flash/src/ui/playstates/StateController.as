package ui.playstates {
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import pyrokid.*;
	import flash.display.Sprite;
	import ui.LevelsInfo;
	import Utils;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class StateController extends Sprite
	{
		public static var display:Sprite = new Sprite();
		
		public static const allowLevelEditor:Boolean = true;
		
		private static var currGameController:GameController = null;
		
		public function StateController() 
		{
			display = new Sprite();
			goToMainMenu();
		}
		
		public static function goToMainMenu(e:Event=null) {
			Utils.removeAllChildren(display);
			
			if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
			
			display.addChild(new MainMenu());
		}
		
		public static function goToLevelSelect(e:Event=null) {
			Utils.removeAllChildren(display);
			
			if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
			
			display.addChild(new LevelSelect());
		}
        
        public static function goToLevelEditor():void {
            LevelsInfo.currLevel = -1; // not in numbered level
            goToGame();
            currGameController.toggleLevelEditor();
        }
		
		public static function goToGame():void {
            var level:Object = LevelsInfo.getCurrLevelRecipe();
			Utils.removeAllChildren(display);
            
			if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
			            
            currGameController = new GameController(level);
            display.addChild(currGameController);
		}
		
		public static function restartCurrLevel(e:Event = null):void {
			StateController.goToGame();
		}
		
		public static function goToCompletedLevel(e:Event=null):void {
			Utils.removeAllChildren(display);
			
			display.addChild(new CompletedLevel());
		}
        
        public static function goToOptions(e:Event=null):void {
			Utils.removeAllChildren(display);
			
            if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
            
			display.addChild(new OptionsMenu());
		}
		
		public static function goToCredits(e:Event=null):void {
			Utils.removeAllChildren(display);
			
            if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
            
			display.addChild(new Credits());
		}
		
		public static function displayHowToPlay(e:Event=null):void {
			display.addChild(new HowToPlayMenu());
		}
		
		//public static function displayPause(e:Event=null) {
			//display.addChild(new PauseMenu());
		//}
		
		public static function displayOptions(e:Event=null):void {
			display.addChild(new OptionsMenu());
		}
		
		public static function removeOverlayedScreen(screen:BasePlayState):void {
			screen.removeAllEventListeners();
			display.removeChild(screen);
		}
		
	}

}