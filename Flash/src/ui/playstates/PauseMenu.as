package ui.playstates {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import pyrokid.GameController;
	import pyrokid.Main;
	import ui.buttons.MenuButton;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class PauseMenu extends BasePlayState
	{
		
		private var game_controller:GameController;
		
		public function PauseMenu(game_contr:GameController) 
		{
			//super(); //do not call this because it uses a different background
			game_controller = game_contr;
			
			defaultBackground = new Shape(); // initializing the variable named rectangle
			defaultBackground.graphics.beginFill(0x8C8C8C,0.5); // choosing the colour for the fill, here it is red
			defaultBackground.graphics.drawRect(0, 0, Main.MainStage.stageWidth,Main.MainStage.stageHeight); // (x spacing, y spacing, width, height)
			defaultBackground.graphics.endFill(); // not always needed but I like to put it in to end the fill
			addChild(defaultBackground); // adds the rectangle to the stage
			
			var pauseTextFormat:TextFormat = new TextFormat();
			pauseTextFormat.size = 60;
			pauseTextFormat.align = TextFormatAlign.CENTER;
			pauseTextFormat.font = "Arial";
			pauseTextFormat.color = 0xFFFFFF;
			addTextToScreen("PAUSED", 800, 100, 400, 70, pauseTextFormat);
			
			addButton(new MenuButton("Resume", 400, 200), unpauseGame);
			addButton(new MenuButton("Restart Level", 400, 250), StateController.restartCurrLevel);
			addButton(new MenuButton("Levels", 400,300), StateController.goToLevelSelect);
			//addButton(new MenuButton("Options", 400,350), StateController.displayOptions);
			addButton(new MenuButton("Main Menu", 400,350), StateController.goToMainMenu);
			//addChild(new LevelEditorButton(StateController.goToLevelSelect, 80, 40, Main.MainStage.stageWidth / 2, 200, ["Resume"], [LevelEditorButton.upColor]));
			//addChild(new LevelEditorButton(StateController.restartCurrLevel, 80, 40, Main.MainStage.stageWidth / 2, 260, ["Restart Level"], [LevelEditorButton.upColor]));
			//addChild(new LevelEditorButton(StateController.goToLevelSelect, 80, 40, Main.MainStage.stageWidth / 2, 320, ["Level Select"], [LevelEditorButton.upColor]));
			//addChild(new LevelEditorButton(StateController.displayOptions, 80, 40, Main.MainStage.stageWidth / 2, 380, ["Options"], [LevelEditorButton.upColor]));
			//addChild(new LevelEditorButton(StateController.goToMainMenu, 80, 40, Main.MainStage.stageWidth / 2, 440, ["Main Menu"], [LevelEditorButton.upColor]));
			
		}
		
		
		private function unpauseGame(e:Event):void {
			removeAllEventListeners();
			Utils.removeAllChildren(this);
			game_controller.removeChild(this);
			game_controller.isPaused = false;
		}
		
		private function goToPreviousScreen(e:Event = null):Function {
			var self:BasePlayState = this;
			return function():void {
				StateController.removeOverlayedScreen(self);
			}
		}
	}

}