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
		
		public static function goToLevelSelect(e:Event=null,pageNum:int = 1) {
			Utils.removeAllChildren(display);
			
			if (currGameController != null) {
				currGameController.destroy();
				currGameController = null;
			}
			
			display.addChild(new LevelSelect(pageNum));
		}
		
		public static function goToLevelSelectAtPage(pageNum:int) {
			return function() {
				goToLevelSelect(null, pageNum);
			};
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
        
		public static function doOnLevelComplete(completedFrameCount:int):void {
            if (LevelsInfo.currLevel == 1) {
                var version:String = Constants.IS_VERSION_A ? "A" : "B";
                Main.log.logEvent(3, "ABversion:" + version);
            }
			LevelsInfo.setCurrentLevelAsCompleted(completedFrameCount);
            LevelSelect.startAndSetLevel(LevelsInfo.currLevel + 1)();
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
            displayOptions(false, Constants.WIDTH / 2, Constants.HEIGHT / 2);
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
		
		//public static function displayPause(level:Level) {
			//display.addChild(new PauseMenu(level));
		//}
        //
        //public static function deletePause() {
            //display.removeChild(
        //}
		
		public static function displayOptions(inPauseMenu:Boolean = false, x:int = 0, y:int = 0):void {
			display.addChild(new OptionsMenu(inPauseMenu, x, y));
		}
		
		public static function removeOverlayedScreen(screen:BasePlayState):void {
			screen.removeAllEventListeners();
			display.removeChild(screen);
		}
		
	}

}