package ui.playstates {
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import pyrokid.*;
	import flash.display.Sprite;
	import pyrokid.tools.Utils;
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
		
		
		//public static function goToLevelEditor(level:Level=null,reloadLevel:Function=null):Function {
			//return function() {
				//Utils.removeAllChildren(StateController.display);
				//var editor:LevelEditor;
				//if (level == null) { //empty level editor
					//editor = new LevelEditor(new Level(LevelRecipe.generateTemplate(16, 10)));
				//} else {
					//trace("making editor");
					//editor = new LevelEditor(level);
					//editor.reloadLevel = reloadLevel;
				//}
				//StateController.display.addChild(editor);
				//StateController.display.addChild(new LevelEditorButton(StateController.goToMainMenu, 80, 40, 0,0, ["Main"], [LevelEditorButton.upColor]));
//
			//}
		//}
		
		public static function goToGame(level:Object, editor:LevelEditor = null):Function {
			if (!(level is ByteArray || level is LevelRecipe)) {
				throw new Error("tried to start gamecontroller with bad level input (says StateController)");
			}
			if (editor != null) {
				editor.turnEditorOff();
			}
			
			if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
			
			return function():void {
				Utils.removeAllChildren(display);
				
				currGameController = new GameController(level);
				display.addChild(currGameController);
			}
			
		}
		
		public static function goToCompletedLevel(e:Event=null) {
			Utils.removeAllChildren(display);
			
			display.addChild(new CompletedLevel());
		}
		
		public static function goToCredits(e:Event=null) {
			Utils.removeAllChildren(display);
			
			display.addChild(new Credits());
		}
		
		public static function displayHowToPlay(e:Event=null) {
			display.addChild(new HowToPlayMenu());
		}
		
		public static function displayPause(e:Event=null) {
			display.addChild(new PauseMenu());
		}
		
		public static function displayOptions(e:Event=null) {
			display.addChild(new OptionsMenu());
		}
		
		public static function removeOverlayedScreen(screen:BasePlayState) {
			screen.removeAllEventListeners();
			display.removeChild(screen);
		}
		
	}

}