package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Main extends Sprite {
        
        private var level:Level;
        
        
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
		
		private static function levelEditorController(e:KeyboardEvent):void {
			if (e.keyCode == 80) {
				trace("p pressed");
				var example = new FileReferenceExample1();
			} else if (e.keyCode == 79) {
				trace("o pressed");
				var bytes:ByteArray = new ByteArray;
				var dummy = { one:"oneeee", two:"twoooo", three:"threeeeeeee", four:4 };
				bytes.writeObject(dummy);
				var fileRef:FileReference = new FileReference();
				fileRef.save(bytes, "poop.txt");
			}
        }
		
		private function doStuff():void {
			stage.addEventListener(KeyboardEvent.KEY_UP, levelEditorController);
		}
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            Key.init(stage);
			doStuff();
            
            level = new Level(new LevelRecipe());
            addChild(level);
            
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        private function update(event:Event):void {
            for (var i:int = 0; i < level.dynamics.length; i++) {
                PhysicsHandler.gravitize(level.dynamics[i], level.walls, level.dynamics);
            }
            
            PhysicsHandler.handlePlayer(level.player, level.walls, level.dynamics)
        }
    }

}