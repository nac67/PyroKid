package pyrokid {
    import flash.utils.ByteArray;
    /**
     * Since we need to embed every asset into the compiled SWF file, all
     * assets must be known at compile time. This creates the unfortunate situation
     * where every single text file, image file, and sound file, will be hard coded
     * into this file. We will look them up with the public static variables.
     * @author Nick Cheng
     */
    public class Embedded {
        
        [Embed(source="../../assets/nicklevel.txt", mimeType="application/octet-stream")]
        private static var Level1:Class;
        public static var level1b:ByteArray = new Level1();
        
    }

}