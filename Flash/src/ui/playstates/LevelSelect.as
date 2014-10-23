package ui.playstates {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import pyrokid.Embedded;
	import pyrokid.Main;
	import ui.LevelEditorButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelSelect extends BasePlayState
	{
		
		private static var levelDict:Dictionary = new Dictionary();
		levelDict[1] = Embedded.levelAaronTest;
		levelDict[2] = Embedded.level1b;
		levelDict[3] = Embedded.level2b;
			
		public static var currLevel:int;
		
		
		public function LevelSelect() 
		{
			super();
			
			
			
			addChild(new LevelEditorButton(startAndSetLevel(1), 80, 40, 80, Main.MainStage.stageHeight/2, ["1"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(2), 80, 40, 180, Main.MainStage.stageHeight/2, ["2"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(3), 80, 40, 280, Main.MainStage.stageHeight/2, ["3"], [LevelEditorButton.upColor]));


		}
		
		public static function startAndSetLevel(levelNum:int):Function {
			return function():void {
				
				if (levelDict[levelNum] == undefined) {
					StateController.goToCredits();
				} else {
					currLevel = levelNum;
				
					StateController.goToGame(levelDict[levelNum])();
				}
				
			}
		}
		
		public static function restartCurrLevel(e:Event = null):void {
			StateController.goToGame(levelDict[currLevel])();
		}
		
	}

}