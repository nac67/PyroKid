package ui.playstates {
    import pyrokid.Embedded;
    import pyrokid.Constants;
    import ui.buttons.CoreButton;
    
	public class MainMenu extends BasePlayState {
		
		public function MainMenu() {
			addChild(new Embedded.MainMenuSWF());
            
            addCoreButton(CoreButton.create(140, 29, StateController.goToLevelSelect, "Start Game").centerOn(600, 350));
            addCoreButton(CoreButton.create(140, 29, StateController.goToCredits, "Credits").centerOn(600, 400));
            addCoreButton(CoreButton.create(140, 29, StateController.goToOptions, "Options").centerOn(600, 450));
			
			if (Constants.LEVEL_EDITOR_ENABLED) {
				addCoreButton(CoreButton.create(140, 29, StateController.goToLevelEditor, "Level Editor").centerOn(600, 500));
			}
		}
	}
}