package pyrokid.graphics {
    import adobe.utils.CustomActions;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ConnectedTest extends Sprite {
        [Embed(source="../../../assets/tile_art/test1.png")]
        public static var TestBMP1:Class;
        
        [Embed(source="../../../assets/tile_art/test2.png")]
        public static var TestBMP2:Class;
        
        public function ConnectedTest() {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        public function init(e:Event = null):void {
            var texMap:Object = new Object();
            texMap["1"] = (new TestBMP1() as Bitmap).bitmapData;
            texMap["2"] = (new TestBMP2() as Bitmap).bitmapData;
            
            var texIDs:Array = [
                [0, 1, 1, 2, 2, 2, 1, 1, 0, 0],
                [0, 1, 1, 2, 2, 2, 1, 1, 0, 0],
                [0, 1, 0, 0, 2, 0, 2, 1, 0, 0],
                [0, 1, 1, 2, 2, 0, 2, 2, 2, 2],
                [0, 1, 1, 2, 2, 0, 2, 1, 0, 0],
                [0, 1, 0, 0, 0, 2, 1, 1, 0, 0]
            ];
            
            var sprite:Bitmap = ConnectedSpriteBuilder.buildSprite(texIDs, texMap, new ConnectedSpriteOptions());
            addChild(sprite);
            sprite.x = 0;
            sprite.y = 0;
            
            return;
        }
    }
}