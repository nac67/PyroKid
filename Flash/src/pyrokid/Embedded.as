package pyrokid {
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.utils.ByteArray;
    /**
     * Since we need to embed every asset into the compiled SWF file, all
     * assets must be known at compile time. This creates the unfortunate situation
     * where every single text file, image file, and sound file, will be hard coded
     * into this file. We will look them up with the public static variables.
     * @author Nick Cheng
     */
    public class Embedded {
        
        //[Embed(source="../../assets/nicklevel.txt", mimeType="application/octet-stream")]
        //private static var Level1:Class;
        //public static var level1b:ByteArray = new Level1();
        
        [Embed(source="../../assets/tile_art/dirt.png")]
        public static var DirtBMP:Class;
        
        [Embed(source="../../assets/tile_art/big_background.png")]
        public static var BGBMP:Class;
        
        [Embed(source='../../assets/swf/player.swf', symbol='playerLegs')]
        public static var PlayerLegsSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/player.swf', symbol='playerTorso')]
        public static var PlayerTorsoSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/fireball.swf')]
        public static var FireballSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/firesploosh.swf', symbol='Sploosh')]
        public static var FiresplooshSWF:Class; //cast as MovieClip on instantiation
        
        [Embed(source='../../assets/swf/spider.swf', symbol='Spider')]
        public static var SpiderSWF:Class; //cast as MovieClip on instantiation
        
    }

}