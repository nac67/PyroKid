package pyrokid
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import ui.*;
	
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class MenuScreen extends Sprite 
	{
		
		public static const STATE_START:int = 0;
		public static const STATE_GAME_OVER:int = 1;
		public static const STATE_PAUSE:int = 2;
		
		private var curr_state:int;
		private var main:Main;
		private var didPlayerWin:Boolean;
		
		public var showStartMenuFunc:Function;
		public var startGameFunc:Function;
		public var quitGameFunc:Function;
		
		public var go_to_next_screen:Boolean = false;
		
		
		public function MenuScreen(game_state:int, mainObj:Main, didPlayerWin:Boolean = false ):void
		{
			super();
			
			curr_state = game_state;
			main = mainObj;
			this.didPlayerWin = didPlayerWin;
			
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
		
		private function generateStartGameFunc(levelNum:int):Function {
			return function():void {
				startGameFunc(levelNum);
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
					welcomeText.text = String("Welcome to PyroKid!");
					welcomeText.y = stage.stageHeight / 3 - welcomeText.textHeight / 2;
					
					var format:TextFormat = new TextFormat();
					format.align = TextFormatAlign.CENTER;
					format.font = "Arial";
					format.size = 15;
					welcomeText.setTextFormat(format);
					
					
					addChild(welcomeText);
					for (var i:int = -1; i < 3; i++) {
						addChild(new LevelEditorButton(generateStartGameFunc(i), 80, 40,300 + (200*i), stage.stageHeight / 2, ["Start Level "+i], [LevelEditorButton.upColor]));
					}
					
					break;
				case STATE_GAME_OVER:
					var byeText:TextField = new TextField();
					byeText.width = stage.stageWidth;
					var playerWinText:String = didPlayerWin ? "\n\nYou Won!" : "You Lost!";
					byeText.text = String("Game Over!\n\n"+playerWinText);
					byeText.y = stage.stageHeight / 3 - byeText.textHeight / 2;
					
					var format2:TextFormat = new TextFormat();
					format2.align = TextFormatAlign.CENTER;
					format2.font = "Arial";
					format2.size = 15;
					byeText.setTextFormat(format2);
					
					
					addChild(byeText);
					
					addChild(new LevelEditorButton(showStartMenuFunc, 160, 40,stage.stageWidth/2, stage.stageHeight / 2, ["Go Back to Main Menu"], [LevelEditorButton.upColor]));

					
					break;
			}
		}
		
		public function removeListeners():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
	}

}