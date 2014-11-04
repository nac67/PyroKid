package ui.playstates {
	import pyrokid.Main;
	import ui.buttons.MenuButton;
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
			
			
			addTextToScreen("Created by:\n\nNick Cheng\nMichelle Liu\nAaron Nelson\nEvan Niederhoffer\nCristian Zaloj",200,200,400,300);
			
			addButton(new MenuButton("Back", 400, 500), StateController.goToMainMenu);
			//addChild(new LevelEditorButton(StateController.goToMainMenu, 80, 40, Main.MainStage.stageWidth/2,Main.MainStage.stageHeight-100, ["Main Menu"], [LevelEditorButton.upColor]));
		}
		
	}

}