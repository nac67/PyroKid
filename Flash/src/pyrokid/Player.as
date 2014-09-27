package pyrokid {
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    
    /**
     * Player can be any width <= 50
     * @author Nick Cheng
     */
    public class Player extends PhysicsObject {
        
        [Embed(source="../../assets/diggity.txt",mimeType="application/octet-stream")]
        private var TestText : Class; 
        var b:ByteArray = new TestText();

        
        public function Player() {
            this.isPlayer = true;
            
            graphics.lineStyle(0x000000);
            graphics.beginFill(0xCCCCFF);
            graphics.drawRect(0, 0, 30, Constants.CELL);
            graphics.endFill();
            
            w = 30;
        
            var s:String = b.readUTFBytes(b.length);
            trace(s);
            
        }
    
    }

}