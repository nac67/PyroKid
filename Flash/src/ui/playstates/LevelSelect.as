package ui.playstates {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import pyrokid.Constants;
    import pyrokid.Constants;
	import pyrokid.Embedded;
	import Main;
	import ui.buttons.CompletedButton;
	import ui.buttons.LockedButton;
	import ui.buttons.UnlockedButton;
	import ui.LevelEditorButton;
	import ui.LevelsInfo;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelSelect extends BasePlayState
	{
		//which page of levels are we currently displaying
		private var curr_page:int = 1;
		
		
		//GRID CONSTANTS
		//offset for grid of buttons from the top left corner of the screen
		var x_offset:int = 300;
		var y_offset:int = 200;
		
		//how much space to leave between each button
		var x_spacing:int = 100;
		var y_spacing:int = 100;
		
		//how many buttons to have in a row and column per screen
		public static var x_tiles:int = 3;
		public static var y_tiles:int = 3;
		
		//PUBLICLY ACCESSIBLE VALUES
		public static var levelsPerPage:Number = x_tiles * y_tiles;
		
		public function LevelSelect() {
			super();
			displayLevelButtons();
		}
		
		private function displayLevelButtons():void {
			addChild(background);
					
			if (curr_page == 1) {
				for (var x:int = 0; x < x_tiles; x++) {
					for (var y:int = 0; y < y_tiles; y++) {
						var curr_level_num:int = ((curr_page-1) * (x_tiles * y_tiles)) + (y * x_tiles + (x + 1));
						if (curr_level_num > LevelsInfo.numOfTutorialLevels) {
							break;
						}
						if (LevelsInfo.levelDict[curr_level_num] != undefined) { //If this level exits, make the button
							//var buttonString:String = LevelsInfo.isLevelLocked(curr_level_num) ? "" + curr_level_num + " (LOCKED)" : "" + curr_level_num;
							//addChild(new LevelEditorButton(startAndSetLevel(curr_level_num), 80, 40, x_offset+(x_spacing*x), y_offset+(y_spacing*y), [buttonString], [LevelEditorButton.upColor]));
							if (LevelsInfo.isLevelLocked(curr_level_num) && !Constants.ALL_LEVELS_UNLOCKED) {
								addButton(new LockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), function() {});
							} else if (LevelsInfo.isLevelCompleted(curr_level_num)) {
								addButton(new CompletedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
							} else {
								addButton(new UnlockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
							}
							
						}
					}
				}
			} else {
				//if (LevelsInfo.isPageLocked(curr_page)) {
					//for (var x:int = 0; x < x_tiles; x++) {
						//for (var y:int = 0; y < y_tiles; y++) {
							//var curr_level_num:int = ((curr_page-2) * (x_tiles * y_tiles)) + (y * x_tiles + (x + 1)) + LevelsInfo.numOfTutorialLevels;
							//if (LevelsInfo.levelDict[curr_level_num] != undefined) { //If this level exits, make the button
								//addButton(new LockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), function() {});
							//}
						//}
					//}
				//} else {
					for (var x:int = 0; x < x_tiles; x++) {
						for (var y:int = 0; y < y_tiles; y++) {
							var curr_level_num:int = ((curr_page-2) * (x_tiles * y_tiles)) + (y * x_tiles + (x + 1)) + LevelsInfo.numOfTutorialLevels;
							if (LevelsInfo.levelDict[curr_level_num] != undefined) { //If this level exits, make the button
								//var buttonString:String = LevelsInfo.isLevelLocked(curr_level_num) ? "" + curr_level_num + " (LOCKED)" : "" + curr_level_num;
								//addChild(new LevelEditorButton(startAndSetLevel(curr_level_num), 80, 40, x_offset+(x_spacing*x), y_offset+(y_spacing*y), [buttonString], [LevelEditorButton.upColor]));
								if (LevelsInfo.isPageLocked(curr_page) && !Constants.ALL_LEVELS_UNLOCKED) {
									addButton(new LockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), function() {});
								} else if (LevelsInfo.isLevelCompleted(curr_level_num)) {
									addButton(new CompletedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
								} else {
									addButton(new UnlockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
								}
							}
						}
					}
				//}
			}
			
			
			
			
			//display paging buttons
			
			if (curr_page > 1) addButton(new UnlockedButton("<", 100, 300), goToPreviousPage);
			var max_level_displayed = (curr_page-1) * (x_tiles * y_tiles) + LevelsInfo.numOfTutorialLevels;
			if (max_level_displayed < LevelsInfo.getTotalNumberOfLevels()) addButton(new UnlockedButton(">", 700, 300), goToNextPage);;
		}
		
		private function goToPreviousPage(e:Event):void {
			Utils.removeAllChildren(this);
			curr_page--;
			if (curr_page < 1) curr_page = 1;
			displayLevelButtons();
		}
		private function goToNextPage(e:Event):void {
			Utils.removeAllChildren(this);
			curr_page++;
			//if (curr_page < 0) curr_page = 0; //TODO: put in max_page logic
			displayLevelButtons();
		}
		private function goToPageNum(pageNum:int):Function {
			var screen:Sprite = this;
			return function():void {
				Utils.removeAllChildren(screen);
				curr_page = pageNum;
				//if (curr_page < 0) curr_page = 0; //TODO: put in max_page logic
				displayLevelButtons();
			}
		}

        public static function startAndSetLevel(levelNum:int, levelWon:Boolean = false):Function {
			return function():void { 
					var levelDict:Dictionary = LevelsInfo.levelDict;
					
					if (levelDict[levelNum] == undefined) {
						StateController.goToCredits();
					} else {
						LevelsInfo.currLevel = levelNum;
						StateController.goToGame(levelDict[levelNum], levelWon)();
					}
					
				}			
		}
		
		//Given a level number, return the number of the page it belongs to
		public static function levelToPageNum(levelNum:int):int {
			return ((levelNum - LevelsInfo.numOfTutorialLevels - 1) / (levelsPerPage)) + 2;
		}
		
		
	}

}