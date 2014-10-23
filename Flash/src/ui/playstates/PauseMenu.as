package ui.playstates {
	import flash.display.Shape;
	import flash.events.Event;
	import pyrokid.Main;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class PauseMenu extends BasePlayState
	{
		
		public function PauseMenu() 
		{
			//super(); //do not call this because it uses a different background
			
			defaultBackground = new Shape(); // initializing the variable named rectangle
			defaultBackground.graphics.beginFill(0x8C8C8C,0.5); // choosing the colour for the fill, here it is red
			defaultBackground.graphics.drawRect(0, 0, Main.MainStage.stageWidth,Main.MainStage.stageHeight); // (x spacing, y spacing, width, height)
			defaultBackground.graphics.endFill(); // not always needed but I like to put it in to end the fill
			addChild(defaultBackground); // adds the rectangle to the stage
			
			//addChild(new LevelEditorButton(StateController.goToLevelSelect, 80, 40, Main.MainStage.stageWidth / 2, 200, ["Resume"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(LevelSelect.restartCurrLevel, 80, 40, Main.MainStage.stageWidth / 2, 260, ["Restart Level"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(StateController.goToLevelSelect, 80, 40, Main.MainStage.stageWidth / 2, 320, ["Level Select"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(StateController.displayOptions, 80, 40, Main.MainStage.stageWidth / 2, 380, ["Options"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(StateController.goToMainMenu, 80, 40, Main.MainStage.stageWidth / 2, 440, ["Main Menu"], [LevelEditorButton.upColor]));
			
		}
		
		
		
		
		private function goToPreviousScreen(e:Event = null):Function {
			var self:BasePlayState = this;
			return function():void {
				StateController.removeOverlayedScreen(self);
			}
		}
	}

}