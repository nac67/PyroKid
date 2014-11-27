package ui {
    import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import pyrokid.Constants;
	import pyrokid.Embedded;
    import pyrokid.LevelRecipe;
	import ui.playstates.LevelSelect;
    import pyrokid.GameSettings;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelsInfo 
	{
		public static var levelDict:Array = [
            null, // No level 0
            /*01*/Embedded.firstIntroTown,
            /*02*/Embedded.secondIntroTown,
            /*03*/Embedded.thirdIntroTown,
            /*04*/Embedded.fourthIntroTown,
            /*05*/Embedded.introFallUnderground,
            /*06*/Embedded.levelLearnDirectionalShoot,
            /*07*/Embedded.level5,
            /*08*/Embedded.alevel1,
            /*09*/Embedded.level4New,
            /*10*/Embedded.level6,
            /*11*/Embedded.level7,
            /*12*/Embedded.alevel2,
            /*13*/Embedded.introSpider,
            /*14*/Embedded.alevel10,
            /*15*/Embedded.wBatIntro, // lizard intro
            /*16*/Embedded.level10,
            /*17*/Embedded.levelLearnShootDown,
            /*18*/Embedded.level8,
            /*19*/Embedded.alevel4,
            /*20*/Embedded.alevel5,
            /*21*/Embedded.alevel9,
            /*22*/Embedded.alevel8,
            /*23*/Embedded.alevel6,
            /*24*/Embedded.alevel12,
            /*25*/Embedded.learnToSmoosh,
            /*26*/Embedded.alevel13,
            /*27*/Embedded.wBat8,
            /*28*/Embedded.wBat1,
            /*29*/Embedded.wBat5,
            /*30*/Embedded.wBat2,
            /*31*/Embedded.wBat6,
            /*32*/Embedded.wBat3,
            /*33*/Embedded.level11,
            /*34*/Embedded.alevel7, // hard spider thing
            /*35*/Embedded.alevel3, // hard lizard thing
            /*36*/Embedded.shootInCorrectOrder,
            /*37*/Embedded.nickDrop,
            /*38*/Embedded.nickAnvil,
            /*39*/Embedded.runFast,
            /*40*/Embedded.level12,
            /*41*/Embedded.wBat9,
            /*42*/Embedded.spiderFun,
            /*43*/Embedded.mazeRunner,
            /*44*/Embedded.level13,
            /*45*/Embedded.clevel1,
            /*46*/Embedded.clevel2,
            /*47*/Embedded.wBat7,
            /*48*/Embedded.level14,
        ];
		
		private static var _currLevel:int = 1;
        
        public static function get currLevel():int {
            return _currLevel;
        }
        
        public static function set currLevel(lvl:int):void {
            _currLevel = lvl;
        }
        
        public static function getCurrLevelRecipe(num = -1):Object {
            var levelToGet:int = (num != -1 ? num : currLevel);
            
            if (levelToGet <= 0 || levelToGet >= levelDict.length) {
                return LevelRecipe.generateTemplate();
            } else {
                var levelBytes:ByteArray = levelDict[levelToGet] as ByteArray;
                levelBytes.position = 0;
                return levelBytes.readObject();
            }
        }
        
		public static var maxUnlockedLevel:int = 1; //TODO: LOAD THIS FROM SHAREDOBJECT
		public static var totalNumberOfLevels:int = -1;
		public static const numOfTutorialLevels:int = 8;
        
		public static var completedLevels:Dictionary = new Dictionary();
		public static var completedLevelsByPage:Dictionary = new Dictionary();
		public static var bestLevelCompletionTimes:Dictionary = new Dictionary();
		
        public static function getTutorialMessages(levelNum:int):Array {
            var level = levelDict[levelNum];
            switch (level) {
                case Embedded.firstIntroTown:
                    var controls:String = GameSettings.controlSchemeInverted ? "arrow" : "WASD";
                    return [[new Vector2(100, 560), "Use the " + controls + " keys to move and jump. Use ESC to pause."]];
                case Embedded.thirdIntroTown:
                    var controls:String = !GameSettings.controlSchemeInverted ? "an arrow key" : "W, A, S, or D";
                    return [[new Vector2(40, 570), "Use " + controls + " to shoot a fireball"]];
                case Embedded.fourthIntroTown: 
                    return [[new Vector2(240, 110), "He's burning houses, get him!"]];
                case Embedded.levelLearnDirectionalShoot:
                    return [[new Vector2(0, 10), "Remember, you can shoot in any direction."]];
                case Embedded.level5: 
                    return [[new Vector2(0, 10), "Latches will hold objects together."]];
                case Embedded.level4New:
                    return [[new Vector2(0, 10), "If you get stuck, you can press R to restart."]];
                case Embedded.levelLearnShootDown:
                    return [[new Vector2(0, 10), "Sometimes you'll need to jump and shoot down at the same time"]];
                case Embedded.level10:
                    return [[new Vector2(0, 10), "You can shoot while falling. At any time\nPress R to restart."]];
                case Embedded.alevel1: 
                    return [[new Vector2(0, 10), "Sometimes you have to make your own exit. Look for a bomb in the cave."]];
                case Embedded.alevel9:
                    return [[new Vector2(0, 10), "Some blocks are guarded by metal edges. Fire will not go past that side."]];
            }
            return [];
        }
        
        public static var tutorialTalisman:Object = {
            2: new Vector2i(10, 7)
        };
        
        public static var tutorialHouses:Object = {
            2: [new Vector2i(34, 6)],
            3: [new Vector2i(22, 6)],
            4: [new Vector2i(33, 4), new Vector2i(23, 4)]
        };
        
        public static var tutorialBuildings:Object = {
            1: [new Vector2i(2, 8), new Vector2i(16, 7), new Vector2i(35, 6)],
            2: [new Vector2i(1, 6), new Vector2i(17, 4)]
        };
		
		public static function getTotalNumberOfLevels():int {
			if (totalNumberOfLevels == -1) {
                totalNumberOfLevels = levelDict.length - 1;
			}
			return totalNumberOfLevels;
		}
		
		public static function restoreCompletedLevels(completedList:Dictionary):void {
			//trace("RESTORING LEVELS");
			for (var currLevel:* in completedList) {
				//trace("current completed level is: " + currLevel);
				var currPage:int = LevelSelect.levelToPageNum(currLevel);
				if (completedLevelsByPage[currPage] == undefined) {
					completedLevelsByPage[currPage] = new Dictionary();
				}
				var completedLevelsForCurrLevelPage:Dictionary = completedLevelsByPage[currPage];
				
				if (completedLevels[currLevel] == undefined) {
					completedLevels[currLevel] = 1;
				}
				if (completedLevelsForCurrLevelPage[currLevel] == undefined) {
					completedLevelsForCurrLevelPage[currLevel] = 1;
				}
			}
		}
		
		//Give this function the # of the level that was just won and it will unlock the next level if needed
		public static function setCurrentLevelAsCompleted(completedFrameCount:int):void {
			var currPage:int = LevelSelect.levelToPageNum(currLevel);
			if (completedLevelsByPage[currPage] == undefined) {
				completedLevelsByPage[currPage] = new Dictionary();
			}
			var completedLevelsForCurrLevelPage:Dictionary = completedLevelsByPage[currPage];
			
			//If level is not yet marked as completed, add it to completed list and completed-by-page list
			if (completedLevels[currLevel] == undefined) {
				completedLevels[currLevel] = 1;
				maxUnlockedLevel++;
			}
			if (completedLevelsForCurrLevelPage[currLevel] == undefined) {
				completedLevelsForCurrLevelPage[currLevel] = 1;
			}
			//if (currLevel == maxUnlockedLevel) {
				//maxUnlockedLevel++;
				//
			//}
			
			//update the best completion time for a level
			if (bestLevelCompletionTimes[currLevel] == undefined) {
				bestLevelCompletionTimes[currLevel] = completedFrameCount;
			} else {
				bestLevelCompletionTimes[currLevel] = Math.min(completedFrameCount, bestLevelCompletionTimes[currLevel]);
			}
			
			Utils.saveLevelData();
			
		}
		
		//Give function a level # to determine if it is locked
		//Returns true only if the level number EXISTS and it is not yet unlocked
		// (The "exists" check is to make the game over screen come up after all levels are won
		public static function isLevelLocked(levelNum:int):Boolean {
			return (levelDict[levelNum] != undefined) && (levelNum > maxUnlockedLevel);
		}
		
		public static function isPageLocked(pageNum:int):Boolean {
			if (pageNum == 1) return false; //page 1 is ALWAYS unlocked
			
			if (completedLevelsByPage[pageNum - 1] == undefined) { //if previous page doesn't have any completed levels, currPage is DEF not unlocked
				return true;
			} else {
				var completedLevelsOnPrevPage:Dictionary = completedLevelsByPage[pageNum - 1];
				var prevLevelsCompleted:Number = Utils.sizeOfDict(completedLevelsOnPrevPage);
				if (pageNum == 1) {
					return false;
				} else if (pageNum == 2) {
					return (prevLevelsCompleted / numOfTutorialLevels) < 1.0;
				} else {
					return (prevLevelsCompleted / LevelSelect.levelsPerPage) < Constants.LEVEL_UNLOCK_NEXT_PAGE_PROPORTION;
				}
			}
		}
        
        public static function getNumOfUnlockedLevelsForPage(pageNum:int):int {
            if (completedLevelsByPage[pageNum] == undefined) { //if previous page doesn't have any completed levels, currPage is DEF not unlocked
				return 0;
			} else {
				var completedLevelsOnPage:Dictionary = completedLevelsByPage[pageNum];
				var levelsCompleted:Number = Utils.sizeOfDict(completedLevelsOnPage);
                return levelsCompleted;
            }
        }
        
        public static function getNumLevelsLeftBeforePageUnlocked(pageNum:int):int {
            var levelsUnlockedOnPrevPage:int = getNumOfUnlockedLevelsForPage(pageNum - 1);
            
            var levelsNeededToUnlockToAdvance:Number = LevelSelect.levelsPerPage * Constants.LEVEL_UNLOCK_NEXT_PAGE_PROPORTION;
            
            return levelsNeededToUnlockToAdvance - levelsUnlockedOnPrevPage;
        }
		
		public static function isLevelCompleted(levelNum:int):Boolean {
			return completedLevels[levelNum] != undefined;
		}
		
	}

}