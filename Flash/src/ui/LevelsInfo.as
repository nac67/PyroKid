package ui {
    import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import pyrokid.Embedded;
    import pyrokid.LevelRecipe;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class LevelsInfo 
	{
		public static var levelDict:Array = [
            null, // No level 0
            //Embedded.level1,
            //Embedded.level2,
            //Embedded.newBlankLevel,
            Embedded.firstIntroTown,
            Embedded.secondIntroTown,
            Embedded.thirdIntroTown,
            Embedded.introFallUnderground,
            Embedded.levelLearnDirectionalShoot,
            Embedded.levelLearnShootDown,
            //Embedded.level3,
            Embedded.level4,
            Embedded.level5,
            Embedded.level6,
            Embedded.level7,
            Embedded.alevel1,
            Embedded.alevel2,
            Embedded.level8,
            Embedded.alevel3,
            Embedded.alevel4,
            Embedded.alevel5,
            Embedded.alevel6,
            Embedded.alevel7,
            Embedded.alevel8,
            Embedded.alevel9,
            Embedded.alevel10,
            Embedded.alevel12,
            Embedded.alevel13,
            Embedded.level9,
            Embedded.level10,
            Embedded.level11,
            Embedded.clevel1,
            Embedded.clevel2,
            Embedded.level12,
            Embedded.level13,
            Embedded.level14,
            Embedded.mazeRunner,
        ];
		
		private static var _currLevel:int = 1;
        
        public static function get currLevel():int {
            return _currLevel;
        }
        
        public static function set currLevel(lvl:int):void {
            _currLevel = lvl;
        }
        
        public static function getCurrLevelRecipe():Object {
            if (currLevel <= 0 || currLevel >= levelDict.length) {
                return LevelRecipe.generateTemplate();
            } else {
                var levelBytes:ByteArray = levelDict[currLevel] as ByteArray;
                levelBytes.position = 0;
                return levelBytes.readObject();
            }
        }
        
		public static var maxUnlockedLevel:int = 1; //TODO: LOAD THIS FROM SHAREDOBJECT
		public static var totalNumberOfLevels:int = -1;
        
        public static var tutorialMessages = {
            1: "Use the WASD keys to move. A and D walk and W jumps. Use ESC to pause.",
            3: "Use an arrow key to charge up a fireball, then release the arrow key to launch it.",
            4: "Certain blocks will react differently to fire.",
            5: "Remember, you can shoot up if you hold the up arrow key.\nLatches will hold objects together.",
            10: "Sometimes you'll need to jump and shoot down at the same time",
            12: "Persistence is key, press R to restart.",
            //30: "Remember, at any time, press R to restart.",
            8: "Sometimes you have to make your own exit. Look for a bomb in the cave.",
            17: "Some blocks are guarded by metal edges. Fire will not go past that side."
        };
        
        public static var tutorialHouses = {
            2: [new Vector2i(34, 6)],
            3: [new Vector2i(22, 6), new Vector2i(34, 6), new Vector2i(43, 6)]
        };
        
        public static var tutorialBuildings = {
            1: [new Vector2i(2, 8), new Vector2i(16, 7), new Vector2i(35, 6)],
            2: [new Vector2i(1, 6), new Vector2i(17, 4)]
        };
		
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