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
		
		public static function goToGame(level:Object, levelWon:Boolean = false, editor:LevelEditor = null):Function {
			Utils.removeAllChildren(display);
			
			if (!(level is ByteArray || level is LevelRecipe)) {
				throw new Error("tried to start gamecontroller with bad level input (says StateController)");
			}
			if (editor != null) {
				editor.turnEditorOff();
			}
			
			if (currGameController != null) {
				currGameController.destroy(!levelWon);
				currGameController = null;
			}
			
			return function():void {
				Utils.removeAllChildren(display);
				
				currGameController = new GameController(level, LevelsInfo.currLevel);
				display.addChild(currGameController);
			}
			
		}
		
		public static function restartCurrLevel(e:Event = null):void {
			StateController.goToGame(LevelsInfo.levelDict[LevelsInfo.currLevel])();
		}
		
		public static function goToCompletedLevel(e:Event=null):void {
			Utils.removeAllChildren(display);
			
			display.addChild(new CompletedLevel());
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