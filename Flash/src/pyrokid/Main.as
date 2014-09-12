package pyrokid
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nick Cheng
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
            
            for (var i = 0; i < Level.level1.length; i++) {
                var row = Level.level1[i];
                for (var j = 0; j < row.length; j++) {
                    var cell = row[j];
                    if (cell == 1) {
                        var a = new GroundTile();
                        a.x = j * 50;
                        a.y = i * 50;
                        addChild(a);
                    }
                }
            }
		}
		
	}
	
}