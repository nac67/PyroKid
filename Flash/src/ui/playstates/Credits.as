package ui.playstates {
    import ui.buttons.CoreButton;
    
	public class Credits extends BasePlayState {
		
		public function Credits() {
			addTextToScreen("Created by:\n\nNick Cheng\nMichelle Liu\nAaron Nelson\nEvan Niederhoffer\nCristian Zaloj", 200, 200, 400, 300);
			addCoreButton(new CoreButton(350, 450, 100, 50, StateController.goToMainMenu, "Main"));
		}
	}
}