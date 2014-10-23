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
		levelDict[1] = Embedded.level1;
		levelDict[2] = Embedded.level2;
		levelDict[3] = Embedded.level3;
		levelDict[4] = Embedded.level4;
		levelDict[5] = Embedded.level5;
		levelDict[6] = Embedded.level6;
		levelDict[7] = Embedded.level7;
		levelDict[8] = Embedded.level8;
		levelDict[9] = Embedded.level9;
		levelDict[10] = Embedded.level10;
		levelDict[11] = Embedded.level11;
		levelDict[12] = Embedded.level12;
		levelDict[13] = Embedded.level13;
		levelDict[14] = Embedded.level14;
			
		public static var currLevel:int;
		
		
		public function LevelSelect() 
		{
			super();
			addChild(new LevelEditorButton(startAndSetLevel(1), 80, 40, 80, 10, ["1"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(2), 80, 40, 180, 10, ["2"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(3), 80, 40, 280, 10, ["3"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(4), 80, 40, 380, 10, ["4"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(5), 80, 40, 80, Main.MainStage.stageHeight/4, ["5"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(6), 80, 40, 180, Main.MainStage.stageHeight/4, ["6"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(7), 80, 40, 280, Main.MainStage.stageHeight/4, ["7"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(8), 80, 40, 380, Main.MainStage.stageHeight/4, ["8"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(9), 80, 40, 80, Main.MainStage.stageHeight/2, ["9"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(10), 80, 40, 180, Main.MainStage.stageHeight/2, ["10"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(11), 80, 40, 280, Main.MainStage.stageHeight/2, ["11"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(12), 80, 40, 380, Main.MainStage.stageHeight/2, ["12"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(13), 80, 40, 80, Main.MainStage.stageHeight*3/4, ["13"], [LevelEditorButton.upColor]));
			addChild(new LevelEditorButton(startAndSetLevel(14), 80, 40, 80, Main.MainStage.stageHeight*3/4, ["14"], [LevelEditorButton.upColor]));


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