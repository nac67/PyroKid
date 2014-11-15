package ui.playstates {
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import Main;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class HowToPlayMenu extends BasePlayState
	{
		
		public function HowToPlayMenu() 
		{
			super();
			
			//addTextToScreen("Use WASD to walk and jump.\nUse arrow keys to aim and shoot fire.");
			
			addChild(new LevelEditorButton(goToPreviousScreen(), 80, 40, 0,0, ["Return"], [LevelEditorButton.upColor]));
		}
		
		private function goToPreviousScreen(e:Event = null):Function {
			var self:BasePlayState = this;
			return function():void {
				StateController.removeOverlayedScreen(self);
			}
		}
		
	}

}