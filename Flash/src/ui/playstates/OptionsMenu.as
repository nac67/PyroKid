package ui.playstates {
	import flash.events.Event;
    import ui.buttons.CoreButton;
    import pyrokid.GameSettings;
    import pyrokid.Embedded;
    import flash.display.Sprite;

	public class OptionsMenu extends BasePlayState {
		
		public function OptionsMenu(inPauseMenu:Boolean = false) {
            super(!inPauseMenu);
            var soundToggle:CoreButton = new CoreButton(60, 50, GameSettings.toggleSound, new Embedded.SoundIcon() as Sprite, new Embedded.SoundMutedIcon() as Sprite);
            soundToggle.centerOn(70, 100);
            if (!GameSettings.soundOn) soundToggle.toggle();
            addCoreButton(soundToggle);
            
            var musicToggle:CoreButton = new CoreButton(60, 50, GameSettings.toggleMusic, new Embedded.MusicIcon() as Sprite, new Embedded.MusicMutedIcon() as Sprite);
            musicToggle.centerOn(70, 200);
            if (!GameSettings.musicOn) musicToggle.toggle();
            addCoreButton(musicToggle);
            
            var controlToggle:CoreButton = new CoreButton(130, 106, GameSettings.toggleControlScheme, new Embedded.ControlsDefaultIcon() as Sprite, new Embedded.ControlsInvertedIcon() as Sprite);
            controlToggle.centerOn(70, 300);
            if (GameSettings.controlSchemeInverted) controlToggle.toggle();
            addCoreButton(controlToggle);
            
            if (!inPauseMenu) {
			    addCoreButton(new CoreButton(100, 50, StateController.goToMainMenu, "Main").centerOn(50, 400));
            }
		}
	}
}