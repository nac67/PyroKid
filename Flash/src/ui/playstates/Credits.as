package ui.playstates {
    import ui.buttons.CoreButton;
    
	public class Credits extends BasePlayState {
		
		public function Credits() {
			var credits_text:String = "\n\n\nCREDITS:\n\n";
			
			credits_text += "Created by:\nNick Cheng, Michelle Liu, Aaron Nelson, Evan Niederhoffer, Cristian Zaloj\n\n";
			credits_text += "Music by WISP X\n\n";
			credits_text += "\"QUICK_SMASH_002.wav\" by JoelAudio used under Creative Commons Attribution 3.0 License \n https://www.freesound.org/people/JoelAudio/sounds/135461/\n\n";
			credits_text += "\"groan.aiff\" by SoundCollectah used under CC0 Public Domain Dedication License \n https://www.freesound.org/people/SoundCollectah/sounds/108927/\n\n";
			credits_text += "\"Bomb - Small\" by Zangrutz used under Creative Commons Attribution 3.0 License \n https://www.freesound.org/people/Zangrutz/sounds/155235/\n\n";
			credits_text += "\"Filth squash2.wav\" by gelo_papas used under Creative Commons Attribution 3.0 License \n http://www.freesound.org/people/gelo_papas/sounds/47341/\n\n";
			
			addTextToScreen(credits_text, 800,600, 400, 300);
			createReturnToMainMenuButton().setCorner(10,10);
		}
	}
}