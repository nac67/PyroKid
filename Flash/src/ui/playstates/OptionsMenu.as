package ui.playstates {
	import flash.events.Event;
    import ui.buttons.CoreButton;
    import pyrokid.GameSettings;
    import pyrokid.Embedded;
    import flash.display.Sprite;
    import pyrokid.Constants;

	public class OptionsMenu extends BasePlayState {
        
        private static var buttonSpacing:int = 10;
        private static var mainButtonSpacing:int = 30;
        private static var smallButtonWidth:int = 60;
        private static var smallButtonHeight:int = 50;
        
        private var inPauseMenu:Boolean;
		
		public function OptionsMenu(inPauseMenu:Boolean = false, x:int = 0, y:int = 0) {
            super(!inPauseMenu);
            this.inPauseMenu = inPauseMenu;
            
            var soundToggle:CoreButton = createCoreButton(60, 50, GameSettings.toggleSound, new Embedded.SoundIcon() as Sprite, new Embedded.SoundMutedIcon() as Sprite);
            if (!GameSettings.soundOn) soundToggle.toggle();
            
            var musicToggle:CoreButton = createCoreButton(60, 50, GameSettings.toggleMusic,
                new Embedded.MusicIcon() as Sprite,
                new Embedded.MusicMutedIcon() as Sprite
            ).setCorner(smallButtonWidth + buttonSpacing, 0);
            if (!GameSettings.musicOn) musicToggle.toggle();
            
            var controlToggle:CoreButton = createCoreButton(130, 106, GameSettings.toggleControlScheme,
                new Embedded.ControlsDefaultIcon() as Sprite,
                new Embedded.ControlsInvertedIcon() as Sprite
            ).setCorner(0, smallButtonHeight + buttonSpacing);
            if (GameSettings.controlSchemeInverted) controlToggle.toggle();
            
            if (!inPauseMenu) {
			    createReturnToMainMenuButton().centerOn(65, 300);
            }
            
            this.x = inPauseMenu ? x : x - 65;
            this.y = inPauseMenu ? y : y - 65;
		}
	}
}