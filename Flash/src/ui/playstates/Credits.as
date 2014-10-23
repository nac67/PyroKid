package ui.playstates {
	import pyrokid.Main;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class Credits extends BasePlayState
	{
		
		public function Credits() 
		{
			super();
			
			
			addCenteredTextToScreen("Created by:\n\nNick Cheng\nMichelle Liu\nAaron Nelson\nEvan Niederhoffer\nCristian Zaloj");
			
			addChild(new LevelEditorButton(StateController.goToMainMenu, 80, 40, Main.MainStage.stageWidth/2,Main.MainStage.stageHeight-100, ["Main Menu"], [LevelEditorButton.upColor]));
		}
		
	}

}