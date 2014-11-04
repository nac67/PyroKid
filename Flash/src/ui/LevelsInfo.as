package ui {
	import flash.utils.Dictionary;
	import pyrokid.Embedded;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelsInfo 
	{
		public static var levelDict:Array = [
            null, // No level 0
            Embedded.level1,
            Embedded.level2,
            Embedded.level3,
            Embedded.level4,
            Embedded.level5,
            Embedded.level6,
            Embedded.level7,
            Embedded.level8,
            Embedded.level9,
            Embedded.level10,
            Embedded.level11,
            Embedded.level12,
            Embedded.level13,
            Embedded.level14,
        ]
		
		public static var currLevel:int = 1;
		public static var maxUnlockedLevel:int = 1; //TODO: LOAD THIS FROM SHAREDOBJECT
		public static var totalNumberOfLevels:int = -1;
			
		public function LevelsInfo() {
		}
		
		public static function getTotalNumberOfLevels():int {
			if (totalNumberOfLevels == -1) {
                totalNumberOfLevels = levelDict.length - 1;
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