package pyrokid {
    import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;
	import flash.events.MouseEvent;
	import ui.*;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Main extends Sprite {
		
		public static var MainStage:Stage;
		
		private const STATE_START:int = 0;
		private const STATE_IN_GAME:int = 1;
		private const STATE_GAME_OVER:int = 2;
		
		private var curr_state:int;
		
		private var startMenu:MenuScreen;
		private var mainGame:GameController;
		private var overMenu:MenuScreen;
        
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
			
			//addEventListener(Event.ENTER_FRAME, update);
			
			createStartMenu();
        }
		
		public function startGameFunc(level_num:int = -1):void //change this to level select maybe? or use parameter
		{
			
			if (level_num == -1) { //default, start normal game controller
				trace("starting level "+level_num);
				Utils.removeAllChildren(this);
				mainGame = new GameController();
				mainGame.createGameOverScreenFunc = createGameOverMenu;
				addChild(mainGame);
				curr_state = STATE_IN_GAME;
			} else {
				trace("asked to start level "+level_num+" but that doesn't exist yet");
			}
			
		}
		
		public function createStartMenu(e:MouseEvent = null):void
		{
			Utils.removeAllChildren(this);
			startMenu = new MenuScreen(MenuScreen.STATE_START, this);
			startMenu.startGameFunc = startGameFunc;
			addChild(startMenu);
			curr_state = STATE_START;
		}
		
		public function createGameOverMenu(didPlayerWin:Boolean = false):void
		{
			Utils.removeAllChildren(this);
			overMenu = new MenuScreen(MenuScreen.STATE_GAME_OVER, this, didPlayerWin);
			overMenu.showStartMenuFunc = createStartMenu;
			addChild(overMenu);
			curr_state = STATE_GAME_OVER;
		}
		
		//private function update(e:Event):void
		//{
			//switch(curr_state)
			//{
				//case STATE_START:
					//if (startMenu.go_to_next_screen) {
						//removeChild(startMenu);
						//mainGame = new GameController();
						//addChild(mainGame);
						//curr_state = STATE_IN_GAME;
					//}
					//break;
				//case STATE_IN_GAME:
					//if (mainGame.isGameOver) {
						//removeChild(mainGame);
						//overMenu = new MenuScreen(MenuScreen.STATE_GAME_OVER, this);
						//addChild(overMenu);
						//curr_state = STATE_GAME_OVER;
					//}
					//break;
				//case STATE_GAME_OVER:
					//if (overMenu.go_to_next_screen) {
						//removeChild(overMenu);
						//startMenu = new MenuScreen(MenuScreen.STATE_START, this);
						//addChild(startMenu);
						//curr_state = STATE_START;
					//}
					//break;
			//}
		//}
		
    }

}