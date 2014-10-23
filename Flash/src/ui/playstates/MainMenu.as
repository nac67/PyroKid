package ui.playstates {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import pyrokid.Embedded;
	import pyrokid.GameController;
	import pyrokid.Main;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class MainMenu extends BasePlayState
	{
		
		public function MainMenu() 
		{
			super();
			
			addCenteredTextToScreen("Welcome to PyroKid!");
			
			addChild(new LevelEditorButton(StateController.goToLevelSelect, 80, 40, Main.MainStage.stageWidth / 2, 260, ["Level Select"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(StateController.displayHowToPlay, 80, 40, Main.MainStage.stageWidth / 2, 320, ["How to Play"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(StateController.displayOptions, 80, 40, Main.MainStage.stageWidth / 2, 380, ["Options"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(StateController.goToCredits, 80, 40, Main.MainStage.stageWidth / 2, 440, ["Credits"], [LevelEditorButton.upColor]));
			
			//if (StateController.allowLevelEditor) {
				//addChild(new LevelEditorButton(StateController.goToLevelEditor(), 80, 40, 0,0, ["Level EDITOR"], [LevelEditorButton.upColor]));
//
			//}
			
		}
		
	}

}