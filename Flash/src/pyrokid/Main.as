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
			
			addEventListener(Event.ENTER_FRAME, update);
			
			startMenu = new MenuScreen(MenuScreen.STATE_START);
			curr_state = STATE_START;
			addChild(startMenu);
        }
		
		private function update(e:Event):void
		{
			switch(curr_state)
			{
				case STATE_START:
					if (startMenu.go_to_next_screen) {
						removeChild(startMenu);
						mainGame = new GameController();
						addChild(mainGame);
						curr_state = STATE_IN_GAME;
					}
					break;
				case STATE_IN_GAME:
					if (mainGame.isGameOver) {
						removeChild(mainGame);
						overMenu = new MenuScreen(MenuScreen.STATE_GAME_OVER);
						addChild(overMenu);
						curr_state = STATE_GAME_OVER;
					}
					break;
				case STATE_GAME_OVER:
					if (overMenu.go_to_next_screen) {
						removeChild(overMenu);
						startMenu = new MenuScreen(MenuScreen.STATE_START);
						addChild(startMenu);
						curr_state = STATE_START;
					}
					break;
			}
		}
		
    }

}