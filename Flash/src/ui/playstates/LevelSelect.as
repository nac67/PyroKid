package ui.playstates {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import pyrokid.CaveBackground;
	import pyrokid.Constants;
    import pyrokid.Constants;
	import pyrokid.Embedded;
	import Main;
    import ui.buttons.CoreButton;
	import ui.buttons.CompletedButton;
	import ui.buttons.LockedButton;
	import ui.buttons.UnlockedButton;
	import ui.LevelEditorButton;
	import ui.LevelsInfo;
    
	public class LevelSelect extends BasePlayState {
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
		
		public function LevelSelect(go_to_page:int = 1) {
			super();
			
			curr_page = go_to_page;
			displayLevelButtons();
		}
		
		private function displayLevelButtons():void {
			addChild(new CaveBackground(10,10));
			
			//display text for top of level select screen
            if (curr_page == 1) {
                addTextToScreen("Tutorial Levels", 200, 50, 400, 100);

            } else if (LevelsInfo.isPageLocked(curr_page)) {
                if (curr_page == 2) {
                   addTextToScreen("Beat tutorial levels to advance", 500, 50, 400, 100);
                } else {
                   var numToUnlock:int = LevelsInfo.getNumLevelsLeftBeforePageUnlocked(curr_page);
                   addTextToScreen("Beat "+numToUnlock+" levels on page "+(curr_page-1)+" to advance", 500, 50, 400, 100);
                }
            } else {
                addTextToScreen("Choose Level", 200, 50, 400, 100);
                
                //if next page exists, show how many levels needed to unlock the next page
                var max_level_displayed = (curr_page-1) * (x_tiles * y_tiles) + LevelsInfo.numOfTutorialLevels;
                if (max_level_displayed < LevelsInfo.getTotalNumberOfLevels()) {
                    var numLevelsToAdvanceNextPage:int = LevelsInfo.getNumLevelsLeftBeforePageUnlocked(curr_page+1);
                    if (numLevelsToAdvanceNextPage > 0) addTextToScreen("Beat "+numLevelsToAdvanceNextPage+" levels on this page to advance", 500, 50, 400, 150);
                }
            }
			
			//display level select page on bottom of page
			addTextToScreen("page " + curr_page, 150, 50, 400, 480);
			
			addChild(createReturnToMainMenuButton().setCorner(10,10));
            
			//draw level buttons
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
								//trace("locked");
								addButton(new LockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), function() {});
							} else if (LevelsInfo.isLevelCompleted(curr_level_num)) {
								//trace("completed");
								addButton(new CompletedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
							} else {
								//trace("unlocked");
								addButton(new UnlockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
							}
							
						}
					}
				}
			} else {
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
								if (LevelsInfo.bestLevelCompletionTimes[curr_level_num] != undefined && (!Constants.IS_VERSION_A || Constants.ALWAYS_DISPLAY_COMPLETION_TIME)) {
									addTextToScreen(Utils.frameCountToTimeDisplay(LevelsInfo.bestLevelCompletionTimes[curr_level_num]), 60, 50, x_offset + (x_spacing * x), y_offset + (y_spacing * y)+40);
								}
                            } else {
                                addButton(new UnlockedButton("" + curr_level_num, x_offset + (x_spacing * x), y_offset + (y_spacing * y)), startAndSetLevel(curr_level_num));
                            }
                        }
                    }
                }
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

        public static function startAndSetLevel(levelNum:int):Function {
			return function():void {
                if (LevelsInfo.levelDict[levelNum] == undefined) {
                    StateController.goToCredits();
                } else {
                    //check if level is on unlocked page
                    var currLevelPage:int = LevelSelect.levelToPageNum(levelNum)
                    //trace("current level, "+levelNum +", on page " +currLevelPage+" is locked = "+LevelsInfo.isPageLocked(currLevelPage));
                    if (LevelsInfo.isPageLocked(currLevelPage)) {
                        StateController.goToLevelSelectAtPage(currLevelPage-1)(); //page for level to start is locked; go to PREVIOUS page
                    } else { //page is not locked, so we can legally start that level
                        LevelsInfo.currLevel = levelNum;
                        StateController.goToGame();
                    }
                }
            }
		}
		
		//Given a level number, return the number of the page it belongs to
		public static function levelToPageNum(levelNum:int):int {
			return ((levelNum - LevelsInfo.numOfTutorialLevels - 1) / (levelsPerPage)) + 2;
		}
	}
}