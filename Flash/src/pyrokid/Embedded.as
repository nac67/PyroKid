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
        
        [Embed(source="../../assets/levels/template.txt", mimeType="application/octet-stream")]
        private static var Level1:Class;
        public static var level1b:ByteArray = new Level1();
        
        [Embed(source="../../assets/levels/template.txt", mimeType="application/octet-stream")]
        private static var LevelAaron:Class;
        public static var levelAaronTest:ByteArray = new LevelAaron();
        
        [Embed(source="../../assets/levels/template.txt", mimeType="application/octet-stream")]
        private static var Level2:Class;
        public static var level2b:ByteArray = new Level2();
        
        [Embed(source="../../assets/levels/template.txt", mimeType="application/octet-stream")]
        private static var Level3:Class;
        public static var level3b:ByteArray = new Level3();
        
        [Embed(source="../../assets/tile_art/dirt.png")]
        public static var DirtBMP:Class;
        
        [Embed(source="../../assets/tile_art/dirt_merge.png")]
        public static var DirtMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/wood_merge.png")]
        public static var WoodMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/metal_merge.png")]
        public static var MetalMergeBMP:Class;
        
        [Embed(source="../../assets/tile_art/big_background.png")]
        public static var BGBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/swf/FireTile.swf', symbol='FireTile')]
        public static var FireTileSWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/Connector.swf', symbol='Connector')]
        public static var ConnectorSWF:Class; //cast as Sprite on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='playerLegs')]
        public static var PlayerLegsSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='playerTorso')]
        public static var PlayerTorsoSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/fireball.swf', symbol='fireball')]
        public static var FireballSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/fireball.swf', symbol='fizzout')]
        public static var FireballFizzSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/firesploosh.swf', symbol='Sploosh')]
        public static var FiresplooshSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/bombdoor.swf', symbol='bombdoor')]
        public static var BombSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='Spider')]
        public static var SpiderSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/waterbat.swf', symbol='WaterBat')]
        public static var WaterBatSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='spiderdie')]
        public static var SpiderDieSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='spiderdie2')]
        public static var SpiderDie2SWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/BurningMan.swf', symbol='BurningMan')]
        public static var BurningManSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/oil.swf', symbol='Oil')]
        public static var OilSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/oil.swf', symbol='Crate')]
        public static var WoodSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/oil.swf', symbol='CrateExplode')]
        public static var WoodExplodeSWF:Class; //cast as MovieClip on instantiation
        
        // should no longer be used
        [Embed(source='../../assets/tile_art/wood.png')]
        public static var WoodBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/tile_art/Metal.png')]
        public static var MetalBMP:Class; //cast as Bitmap on instantiation
        
        [Embed(source='../../assets/swf/crosshair.swf', symbol='crosshair')]
        public static var CrosshairSWF:Class; //cast as MovieClip on instantiation
        
		[Embed(source="../../assets/sound/fireball-sound.mp3")]
		private static var fireballSoundClass:Class;
		public static var fireballSound:Sound = new fireballSoundClass();
    }

}