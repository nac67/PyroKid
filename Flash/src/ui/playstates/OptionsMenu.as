package ui.playstates {
	import flash.events.Event;
    import ui.buttons.CoreButton;
    import pyrokid.GameSettings;
    import pyrokid.Embedded;
    import flash.display.Sprite;

	public class OptionsMenu extends BasePlayState {
		
		public function OptionsMenu(inPauseMenu:Boolean = false) {
            super(!inPauseMenu);
            var soundToggle:CoreButton = new CoreButton(100, 100, 60, 50, GameSettings.toggleSound, new Embedded.SoundIcon() as Sprite, new Embedded.SoundMutedIcon() as Sprite);
            if (!GameSettings.soundOn) soundToggle.toggle();
            addCoreButton(soundToggle);
            
            var musicToggle:CoreButton = new CoreButton(100, 200, 60, 50, GameSettings.toggleMusic, new Embedded.MusicIcon() as Sprite, new Embedded.MusicMutedIcon() as Sprite);
            if (!GameSettings.musicOn) musicToggle.toggle();
            addCoreButton(musicToggle);
            
            var controlToggle:CoreButton = new CoreButton(30, 300, 120, 50, GameSettings.toggleControlScheme, "Default Controls", "Inverted Controls");
            if (GameSettings.controlSchemeInverted) controlToggle.toggle();
            addCoreButton(controlToggle);
            
            if (!inPauseMenu) {
			    addCoreButton(new CoreButton(100, 400, 100, 50, StateController.goToMainMenu, "Main"));
            }
		}
	}
}