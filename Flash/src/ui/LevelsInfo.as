package ui {
	import flash.utils.Dictionary;
	import pyrokid.Embedded;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelsInfo 
	{
		public static const totalNumberOfLevels = 14; //UPDATE THIS WHENEVER ADDING NEW LEVEL, USED FOR PAGES IN LEVEL SELECT
		//TODO: just use the function below that returns number of levels?
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
		public static var maxCompletedLevel:int = 0; //TODO: LOAD THIS FROM SHAREDOBJECT
			
		public function LevelsInfo() 
		{
		
		}
		
		public static function getTotalNumberOfLevels():int {
			var n:int = 0;
			for (var key:* in levelDict) {
				n++;
			}
			return n;
		}
		
	}

}