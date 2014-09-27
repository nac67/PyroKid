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
        
        private var player:Player;
        private var dynamics:Array = [];
        
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
            
            // ---------- BEGIN MESSY TEMPORARY CODE
            for (var i:int = 0; i < Level.level1.length; i++) {
                var row:Array = Level.level1[i];
                for (var j:int = 0; j < row.length; j++) {
                    var cell:int = row[j];
                    if (cell == 1) {
                        var a:GroundTile = new GroundTile();
                        a.x = j * Constants.CELL;
                        a.y = i * Constants.CELL;
                        addChild(a);
                    }
                }
            }
            
            player = new Player();
            player.x = 2 * Constants.CELL;
            player.y = 2 * Constants.CELL;
            addChild(player);
            
            var c:Crate;
            
            c = new Crate();
            c.x = 5 * Constants.CELL;
            c.y = 2 * Constants.CELL;
            addChild(c);
            dynamics.push(c);
            
            c = new Crate();
            c.x = 7 * Constants.CELL;
            c.y = 1 * Constants.CELL;
            c.setCellSize(3, 2);
            addChild(c);
            dynamics.push(c);
            // ---------- END MESSY TEMPORARY CODE
            
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        private function update(event:Event):void {
            for (var i:int = 0; i < dynamics.length; i++) {
                PhysicsHandler.gravitize(dynamics[i], Level.level1, dynamics);
            }
            
            PhysicsHandler.handlePlayer(player, Level.level1, dynamics)
        }
    }

}