package ui.playstates {
    import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import pyrokid.Embedded;
	import pyrokid.GameController;
	import pyrokid.Main;
    import ui.buttons.CoreButton;
	import ui.buttons.MenuButton;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class MainMenu extends BasePlayState
	{
		
		public function MainMenu() 
		{
			super();
			
			//addCenteredTextToScreen("Welcome to PyroKid!");
			
			
			addChild(new Embedded.MainMenuSWF());
			addButton(new MenuButton("Start Game", 600, 350), StateController.goToLevelSelect);
			//addButton(new MenuButton("Instructions", 600, 400), StateController.displayHowToPlay);
			//addButton(new MenuButton("Options", 600, 450), StateController.displayOptions);
			addButton(new MenuButton("Credits", 600, 500), StateController.goToCredits);
			
			
			//if (StateController.allowLevelEditor) {
				//addChild(new LevelEditorButton(StateController.goToLevelEditor(), 80, 40, 0,0, ["Level EDITOR"], [LevelEditorButton.upColor]));
//
			//}
            
            var tracePoo:Function = function():void {
                trace("poo");
            }
            //var butt:CoreButton = CoreButton.createTextButton(100, 35, tracePoo, "swham" , "doo", "two and heif");
            var a = new Embedded.DirtBMP() as DisplayObject;
            var b = new Embedded.MetalBMP() as DisplayObject;
            a.scaleX = a.scaleY = 0.6;
            b.scaleX = b.scaleY = 0.3;
            var butt:CoreButton = new CoreButton(100, 50, tracePoo, "shwam", a, "doo", b);
            butt.x = 100;
            butt.y = 100;
            addChild(butt);
			
		}
		
	}

}