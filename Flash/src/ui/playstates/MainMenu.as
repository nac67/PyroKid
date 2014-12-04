package ui.playstates {
    import flash.display.Bitmap;
    import pyrokid.Embedded;
    import pyrokid.Constants;
    import ui.buttons.CoreButton;
	import ui.levelorderer.LevelOrderer;
    
	public class MainMenu extends BasePlayState {
		
		public function MainMenu() {
			addChild(new Embedded.MainMenuSWF());
            
            addCoreButton(CoreButton.create(140, 29, StateController.goToLevelSelect, "Start Game").centerOn(600, 350));
            addCoreButton(CoreButton.create(140, 29, StateController.goToCredits, "Credits").centerOn(600, 400));
            addCoreButton(CoreButton.create(140, 29, StateController.goToOptions, "Options").centerOn(600, 450));
            
			if (Constants.LEVEL_EDITOR_ENABLED) {
				addCoreButton(CoreButton.create(140, 29, StateController.goToLevelEditor, "Level Editor").centerOn(600, 500));
			}
            addCoreButton(CoreButton.create(140, 29, hardCodedPoop, "Level Orderer").centerOn(600, 550));
		}
        
        public function hardCodedPoop() {
			addChild(new LevelOrderer());
            //for (var i:int = 0 ; i < 40; i++) {
                //var row:int = i / 10;
                //var col:int = i % 10;
                //var icon:Bitmap = Utils.getLevelIcon(i+1);
                //icon.x = col * 80;
                //icon.y = row * 80;
                //icon.scaleX = icon.scaleY = .1;
                //addChild(icon);
            //}
        }
	}
}