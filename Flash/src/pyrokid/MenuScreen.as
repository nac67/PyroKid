package pyrokid
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class MenuScreen extends Sprite 
	{
		
		public static const STATE_START:int = 0;
		public static const STATE_GAME_OVER:int = 1;
		
		private var curr_state:int;
		
		
		public var go_to_next_screen:Boolean = false;
		
		public function MenuScreen(game_state:int ):void
		{
			super();
			
			curr_state = game_state;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			displayMenu();
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SHIFT) {
				removeListeners();
				go_to_next_screen = true;
			}
		}
		
		public function displayMenu():void
		{
			switch(curr_state)
			{
				case STATE_START:
					var welcomeText:TextField = new TextField();
					welcomeText.width = stage.stageWidth;
					welcomeText.height = stage.stageHeight;
					welcomeText.text = String("Welcome to PyroKid!\n\n\nPress SHIFT to start!");
					welcomeText.y = stage.stageHeight / 2 - welcomeText.textHeight / 2;
					
					var format:TextFormat = new TextFormat();
					format.align = TextFormatAlign.CENTER;
					format.font = "Arial";
					format.size = 15;
					welcomeText.setTextFormat(format);
					
					
					addChild(welcomeText);
					break;
				case STATE_GAME_OVER:
					var byeText:TextField = new TextField();
					byeText.width = stage.stageWidth;
					byeText.text = String("Game Over!\n\nPress SHIFT to go back to the start screen.");
					byeText.y = stage.stageHeight / 2 - byeText.textHeight / 2;
					
					var format2:TextFormat = new TextFormat();
					format2.align = TextFormatAlign.CENTER;
					format2.font = "Arial";
					format2.size = 15;
					byeText.setTextFormat(format2);
					
					
					addChild(byeText);
					break;
			}
		}
		
		public function removeListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
	}

}