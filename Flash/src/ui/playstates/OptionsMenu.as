package ui.playstates {
	import flash.events.Event;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class OptionsMenu extends BasePlayState
	{
		
		public function OptionsMenu() 
		{
			super();
			
			
			//addTextToScreen("Options stuff goes here!");
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