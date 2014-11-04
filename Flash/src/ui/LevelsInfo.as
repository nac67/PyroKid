package ui {
	import flash.utils.Dictionary;
	import pyrokid.Embedded;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelsInfo 
	{
		public static var levelDict:Dictionary = new Dictionary();
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
		levelDict[15] = Embedded.level14;
		levelDict[16] = Embedded.level14;
		levelDict[17] = Embedded.level14;
		levelDict[18] = Embedded.level14;
		levelDict[19] = Embedded.level14;
		levelDict[20] = Embedded.level14;
		levelDict[21] = Embedded.level14;
		levelDict[22] = Embedded.level14;
		levelDict[23] = Embedded.level14;
		levelDict[24] = Embedded.level14;
		
		public static var currLevel:int = 1;
		public static var maxUnlockedLevel:int = 1; //TODO: LOAD THIS FROM SHAREDOBJECT
		public static var totalNumberOfLevels:int = -1;
			
		public function LevelsInfo() 
		{
		
		}
		
		public static function getTotalNumberOfLevels():int {
			if (totalNumberOfLevels == -1) {
				totalNumberOfLevels = 0;
				for (var key:* in levelDict) {
					totalNumberOfLevels++;
				}
			}
			return totalNumberOfLevels;
		}
		
		//Give this function the # of the level that was just won and it will unlock the next level if needed
		public static function checkAndUnlockNextLevel():void {
			if (currLevel == maxUnlockedLevel) {
				maxUnlockedLevel++;
				Utils.saveLevelData();
			}
		}
		
		//Give function a level # to determine if it is locked
		//Returns true only if the level number EXISTS and it is not yet unlocked
		// (The "exists" check is to make the game over screen come up after all levels are won
		public static function isLevelLocked(levelNum:int):Boolean {
			//return (levelNum <= getTotalNumberOfLevels) && (levelNum > maxUnlockedLevel);
			return (levelDict[levelNum] != undefined) && (levelNum > maxUnlockedLevel);
		}
		
	}

}