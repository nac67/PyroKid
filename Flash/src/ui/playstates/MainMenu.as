package ui.playstates {
    import pyrokid.Embedded;
    import pyrokid.Constants;
    import ui.buttons.CoreButton;
    
	public class MainMenu extends BasePlayState {
		
		public function MainMenu() {
			addChild(new Embedded.MainMenuSWF());
            
            addCoreButton(new CoreButton(550, 350, 140, 29, StateController.goToLevelSelect, "Start Game"));
            addCoreButton(new CoreButton(550, 400, 140, 29, StateController.goToCredits, "Credits"));
            addCoreButton(new CoreButton(550, 450, 140, 29, StateController.goToOptions, "Options"));
			
			if (Constants.LEVEL_EDITOR_ENABLED) {
				addCoreButton(new CoreButton(550, 500, 140, 29, StateController.goToGame(), "Level Editor"));
			}
		}
	}
}