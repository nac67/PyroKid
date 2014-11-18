package pyrokid {
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.utils.ByteArray;
	import flash.media.Sound;
    /**
     * Since we need to embed every asset into the compiled SWF file, all
     * assets must be known at compile time. This creates the unfortunate situation
     * where every single text file, image file, and sound file, will be hard coded
     * into this file. We will look them up with the public static variables.
     * @author Nick Cheng
     */
    public class Embedded {
        
        [Embed(source='../../assets/tile_art/brick_building.png')]
        public static var BrickBuildingBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/tile_art/house.png')]
        public static var HouseBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source="../../assets/swf/Mob.swf", symbol="Mob")]
        public static var Mob:Class; //cast as Sprite on instantiation
        
        [Embed(source="../../assets/swf/Talisman.swf", symbol="Talisman")]
        public static var Talisman:Class; //cast as Sprite on instantiation
        
        [Embed(source="../../assets/swf/Talisman.swf", symbol="TalismanObtain")]
        public static var TalismanObtain:Class; //cast as Sprite on instantiation
        
        [Embed(source="../../assets/swf/buttons.swf", symbol="Check")]
        public static var CheckIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/buttons.swf', symbol='Sound')]
        public static var SoundIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/buttons.swf', symbol='SoundMuted')]
        public static var SoundMutedIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/buttons.swf', symbol='Music')]
        public static var MusicIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/buttons.swf', symbol='MusicMuted')]
        public static var MusicMutedIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/buttons.swf', symbol='ControlsBTN')]
        public static var ControlsDefaultIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/buttons.swf', symbol='ControlsBTN2')]
        public static var ControlsInvertedIcon:Class; //cast as Sprite on instantiation
        
        [Embed(source="../../assets/levels/introTown2.txt", mimeType="application/octet-stream")]
        private static var FirstIntroTown:Class;
        public static var firstIntroTown:ByteArray = new FirstIntroTown();
        
        [Embed(source="../../assets/levels/mazeRunner3.txt", mimeType="application/octet-stream")]
        private static var MazeRunner:Class;
        public static var mazeRunner:ByteArray = new MazeRunner();
        
        [Embed(source="../../assets/levels_wip/newBlankLevel.txt", mimeType="application/octet-stream")]
        private static var NewBlankLevel:Class;
        public static var newBlankLevel:ByteArray = new NewBlankLevel();
        
        [Embed(source="../../assets/levels/secondIntroTown.txt", mimeType="application/octet-stream")]
        private static var SecondIntroTown:Class;
        public static var secondIntroTown:ByteArray = new SecondIntroTown();
        
        [Embed(source="../../assets/levels/introTown4.txt", mimeType="application/octet-stream")]
        private static var ThirdIntroTown:Class;
        public static var thirdIntroTown:ByteArray = new ThirdIntroTown();
        
        [Embed(source="../../assets/levels/introTownMob.txt", mimeType="application/octet-stream")]
        private static var FourthIntroTown:Class;
        public static var fourthIntroTown:ByteArray = new FourthIntroTown();
        
        [Embed(source="../../assets/levels/introFallUnderground.txt", mimeType="application/octet-stream")]
        private static var IntroFallUnderground:Class;
        public static var introFallUnderground:ByteArray = new IntroFallUnderground();
        
        [Embed(source="../../assets/levels/learnDirectionalShoot.txt", mimeType="application/octet-stream")]
        private static var LevelLearnDirectionalShoot:Class;
        public static var levelLearnDirectionalShoot:ByteArray = new LevelLearnDirectionalShoot();
        
        [Embed(source="../../assets/levels/learnShootDown4.txt", mimeType="application/octet-stream")]
        private static var LevelLearnShootDown:Class;
        public static var levelLearnShootDown:ByteArray = new LevelLearnShootDown();
        
        [Embed(source="../../assets/levels/tut3.txt", mimeType="application/octet-stream")]
        private static var Level3:Class;
        public static var level3:ByteArray = new Level3();
        
        [Embed(source="../../assets/levels/learntosquash.txt", mimeType="application/octet-stream")]
        private static var LearnToSmoosh:Class;
        public static var learnToSmoosh:ByteArray = new LearnToSmoosh();
        
        [Embed(source="../../assets/levels/runFast.txt", mimeType="application/octet-stream")]
        private static var RunFast:Class;
        public static var runFast:ByteArray = new RunFast();
        
        [Embed(source="../../assets/levels/shootInCorrectOrder2.txt", mimeType="application/octet-stream")]
        private static var ShootInCorrectOrder:Class;
        public static var shootInCorrectOrder:ByteArray = new ShootInCorrectOrder();
        
        [Embed(source="../../assets/levels/tut4.txt", mimeType="application/octet-stream")]
        private static var Level4:Class;
        public static var level4:ByteArray = new Level4();
        
        [Embed(source="../../assets/levels/learnCreateMetalPath.txt", mimeType="application/octet-stream")]
        private static var Level4New:Class;
        public static var level4New:ByteArray = new Level4New();
        
        [Embed(source="../../assets/levels/tut5.txt", mimeType="application/octet-stream")]
        private static var Level5:Class;
        public static var level5:ByteArray = new Level5();
        
        [Embed(source="../../assets/levels/tut6.txt", mimeType="application/octet-stream")]
        private static var Level6:Class;
        public static var level6:ByteArray = new Level6();
        
        [Embed(source="../../assets/levels/tut7.txt", mimeType="application/octet-stream")]
        private static var Level7:Class;
        public static var level7:ByteArray = new Level7();
        
        [Embed(source="../../assets/levels/shootdowneasy.txt", mimeType="application/octet-stream")]
        private static var Level8:Class;
        public static var level8:ByteArray = new Level8();
        
        [Embed(source="../../assets/levels/fallylevel.txt", mimeType="application/octet-stream")]
        private static var Level9:Class;
        public static var level9:ByteArray = new Level9();
        
        [Embed(source="../../assets/levels/shoot_while_fall.txt", mimeType="application/octet-stream")]
        private static var Level10:Class;
        public static var level10:ByteArray = new Level10();
        
        [Embed(source="../../assets/levels/fallylevel_hard.txt", mimeType="application/octet-stream")]
        private static var Level11:Class;
        public static var level11:ByteArray = new Level11();
        
        [Embed(source="../../assets/levels/AaronLevel3.txt", mimeType="application/octet-stream")]
        private static var Level12:Class;
        public static var level12:ByteArray = new Level12();
        
        [Embed(source="../../assets/levels/AaronLevel2.txt", mimeType="application/octet-stream")]
        private static var Level13:Class;
        public static var level13:ByteArray = new Level13();
        
        [Embed(source="../../assets/levels/AaronLevel1.txt", mimeType="application/octet-stream")]
        private static var Level14:Class;
        public static var level14:ByteArray = new Level14();
        
        [Embed(source="../../assets/levels/cage.txt", mimeType="application/octet-stream")]
        private static var CLevel1:Class;
        public static var clevel1:ByteArray = new CLevel1();
        
        [Embed(source="../../assets/levels/caution.txt", mimeType="application/octet-stream")]
        private static var CLevel2:Class;
        public static var clevel2:ByteArray = new CLevel2();
        
        [Embed(source="../../assets/tile_art/dirt.png")]
        public static var DirtBMP:Class;
        
        [Embed(source="../../assets/tile_art/dirt_merge.png")]
        public static var DirtMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/wood_merge.png")]
        public static var WoodMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/metal_merge.png")]
        public static var MetalMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/lava.png")]
        public static var LavaMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/big_background.png")]
        public static var BGBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source="../../assets/tile_art/tut_bg1.png")]
        public static var TutorialBackground1:Class; //cast as Bitmap on instantiation
        
        [Embed(source="../../assets/tile_art/tut_bg2.png")]
        public static var TutorialBackground2:Class; //cast as Bitmap on instantiation
        
        [Embed(source="../../assets/tile_art/tut_bg3.png")]
        public static var TutorialBackground3:Class; //cast as Bitmap on instantiation
        
        [Embed(source="../../assets/tile_art/rock.jpg")]
        public static var RockBMP:Class;
        
        [Embed(source='../../assets/swf/FireTileOptimized.swf', symbol='FireTile')]
        public static var FireTileSWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/Douse.swf', symbol='Douse')]
        public static var DouseSWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/Connector.swf', symbol='Connector')]
        public static var ConnectorSWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/Glow.png')]
        public static var GlowBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='playerLegs')]
        public static var PlayerLegsSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='playerTorso')]
        public static var PlayerTorsoSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='dieFire')]
        public static var PlayerDieFireSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='diePain')]
        public static var PlayerDiePainSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/fireball.swf', symbol='fireball')]
        public static var FireballSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/fireball.swf', symbol='fizzout')]
        public static var FireballFizzSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/firesploosh.swf', symbol='Sploosh')]
        public static var FiresplooshSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/bombdoor.swf', symbol='BombAnim')]
        public static var Bomb2SWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/bombdoor.swf', symbol='BombRegular')]
        public static var Bomb1SWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/bombdoor.swf', symbol='BombHoleInWall')]
        public static var Bomb3SWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='Spider')]
        public static var SpiderSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='SpiderArmor')]
        public static var SpiderArmorSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='ArmorFly')]
        public static var ArmorFlySWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/waterbat.swf', symbol='WaterBat')]
        public static var WaterBatSWF:Class; //cast as MovieClip on instantiation
        [Embed(source='../../assets/swf/waterbat.swf', symbol='WaterBatDie')]
        public static var WaterBatDieSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='spiderdie')]
        public static var SpiderDieSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='spiderdie2')]
        public static var SpiderDie2SWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/BurningMan.swf', symbol='BurningMan')]
        public static var BurningManSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/Lizard.swf', symbol='Lizard')]
        public static var LizardSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/oil.swf', symbol='Oil')]
        public static var OilSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/oil.swf', symbol='Crate')]
        public static var WoodSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/oil.swf', symbol='CrateExplode')]
        public static var WoodExplodeSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/tile_art/Metal.png')]
        public static var MetalBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/tile_art/metal_edge.png')]
        public static var MetalEdgeBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/swf/crosshair.swf', symbol='crosshair')]
        public static var CrosshairSWF:Class; //cast as MovieClip on instantiation
        
		[Embed(source="../../assets/sound/fireball-sound.mp3")]
		private static var fireballSoundClass:Class;
		public static var fireballSound:Sound = new fireballSoundClass();
        
        [Embed(source="../../assets/sound/losearmor.mp3")]
		private static var loseArmorSoundClass:Class;
		public static var loseArmorSound:Sound = new loseArmorSoundClass();
        
        [Embed(source="../../assets/sound/spiderdie.mp3")]
		private static var spiderdieSoundClass:Class;
		public static var spiderdieSound:Sound = new spiderdieSoundClass();
        
        [Embed(source="../../assets/sound/bomb.mp3")]
		private static var bombSoundClass:Class;
		public static var bombSound:Sound = new bombSoundClass();
        
        [Embed(source="../../assets/sound/babyjag.mp3")]
		private static var immuneSoundClass:Class;
		public static var immuneSound:Sound = new immuneSoundClass();
        
        [Embed(source="../../assets/sound/squish.mp3")]
		private static var squishSoundClass:Class;
		public static var squishSound:Sound = new squishSoundClass();
        
        [Embed(source="../../assets/sound/Pyrokid_bgm.mp3")]
		private static var musicClass:Class;
		public static var musicSound:Sound = new musicClass();
		
		[Embed(source = "../../assets/swf/mainmenu.swf")]
		public static var MainMenuSWF:Class;
        
        [Embed(source='../../assets/swf/spotlight.swf', symbol='Spotlight')]
        public static var SpotlightSWF:Class; //cast as MovieClip on instantiation
        
        /////////////////
        
        [Embed(source="../../assets/levels/tut8.txt", mimeType="application/octet-stream")]
        private static var ALevel1:Class;
        public static var alevel1:ByteArray = new ALevel1();
        
        [Embed(source="../../assets/levels/tut9.txt", mimeType="application/octet-stream")]
        private static var ALevel2:Class;
        public static var alevel2:ByteArray = new ALevel2();
        
        [Embed(source="../../assets/levels/nlevel2.txt", mimeType="application/octet-stream")]
        private static var ALevel3:Class;
        public static var alevel3:ByteArray = new ALevel3();
        
        [Embed(source="../../assets/levels/nlevel5.txt", mimeType="application/octet-stream")]
        private static var ALevel4:Class;
        public static var alevel4:ByteArray = new ALevel4();
        
        [Embed(source="../../assets/levels/nlevel1.txt", mimeType="application/octet-stream")]
        private static var ALevel5:Class;
        public static var alevel5:ByteArray = new ALevel5();
        
        [Embed(source="../../assets/levels/nlevel4.txt", mimeType="application/octet-stream")]
        private static var ALevel6:Class;
        public static var alevel6:ByteArray = new ALevel6();
        
        [Embed(source="../../assets/levels/nlevel3.txt", mimeType="application/octet-stream")]
        private static var ALevel7:Class;
        public static var alevel7:ByteArray = new ALevel7();
        
        [Embed(source="../../assets/levels/fallingbomb.txt", mimeType="application/octet-stream")]
        private static var ALevel8:Class;
        public static var alevel8:ByteArray = new ALevel8();
        
        [Embed(source="../../assets/levels/introEdges.txt", mimeType="application/octet-stream")]
        private static var ALevel9:Class;
        public static var alevel9:ByteArray = new ALevel9();
        
        [Embed(source="../../assets/levels/introImmuneEnemies.txt", mimeType="application/octet-stream")]
        private static var ALevel10:Class;
        public static var alevel10:ByteArray = new ALevel10();
        
        [Embed(source="../../assets/levels/lotsOfSpiders.txt", mimeType="application/octet-stream")]
        private static var ALevel12:Class;
        public static var alevel12:ByteArray = new ALevel12();
        
        [Embed(source="../../assets/levels/droppingFlames.txt", mimeType="application/octet-stream")]
        private static var ALevel13:Class;
        public static var alevel13:ByteArray = new ALevel13();
        
        // ALL OF NICKS NEW LEVELS START HERE
        
        [Embed(source="../../assets/levels/waterbat4.txt", mimeType="application/octet-stream")]
        private static var WBatIntro:Class;
        public static var wBatIntro:ByteArray = new WBatIntro();
        
        [Embed(source="../../assets/levels/waterbat0.txt", mimeType="application/octet-stream")]
        private static var WBat0:Class;
        public static var wBat0:ByteArray = new WBat0();
        
        [Embed(source="../../assets/levels/waterbat1.txt", mimeType="application/octet-stream")]
        private static var WBat1:Class;
        public static var wBat1:ByteArray = new WBat1();
        
        [Embed(source="../../assets/levels/waterbat2.txt", mimeType="application/octet-stream")]
        private static var WBat2:Class;
        public static var wBat2:ByteArray = new WBat2();
        
        [Embed(source="../../assets/levels/waterbat3.txt", mimeType="application/octet-stream")]
        private static var WBat3:Class;
        public static var wBat3:ByteArray = new WBat3();
        
        [Embed(source="../../assets/levels/waterbat5.txt", mimeType="application/octet-stream")]
        private static var WBat5:Class;
        public static var wBat5:ByteArray = new WBat5();
        
        [Embed(source="../../assets/levels/waterbat6.txt", mimeType="application/octet-stream")]
        private static var WBat6:Class;
        public static var wBat6:ByteArray = new WBat6();
        
        [Embed(source="../../assets/levels/waterbat7.txt", mimeType="application/octet-stream")]
        private static var WBat7:Class;
        public static var wBat7:ByteArray = new WBat7();
        
        [Embed(source="../../assets/levels/waterbat8.txt", mimeType="application/octet-stream")]
        private static var WBat8:Class;
        public static var wBat8:ByteArray = new WBat8();
        
        [Embed(source="../../assets/levels/waterbat9.txt", mimeType="application/octet-stream")]
        private static var WBat9:Class;
        public static var wBat9:ByteArray = new WBat9();
        
        [Embed(source="../../assets/levels/new_nick_droppy.txt", mimeType="application/octet-stream")]
        private static var NickDrop:Class;
        public static var nickDrop:ByteArray = new NickDrop();
        
        [Embed(source="../../assets/levels/new_nick_anvil.txt", mimeType="application/octet-stream")]
        private static var NickAnvil:Class;
        public static var nickAnvil:ByteArray = new NickAnvil();
        
        [Embed(source="../../assets/levels/introspider.txt", mimeType="application/octet-stream")]
        private static var IntroSpider:Class;
        public static var introSpider:ByteArray = new IntroSpider();
        
        [Embed(source="../../assets/levels/usetheenemytokill.txt", mimeType="application/octet-stream")]
        private static var SpiderFun:Class;
        public static var spiderFun:ByteArray = new SpiderFun();
        
		
    }

}