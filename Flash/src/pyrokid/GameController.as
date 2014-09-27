package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
	
	public class GameController extends Sprite {
		
		public var level:Level;
		
		public function GameController() {
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            level = new Level(new LevelRecipe());
            addChild(level);
            addEventListener(Event.ENTER_FRAME, update);
		}

		public function reloadLevel(levelRecipe) {
			removeChild(level);
			level = new Level(levelRecipe);
			addChild(level);
		}
		
		private function levelEditorListener(e:KeyboardEvent):void {
			if (e.keyCode == 79) {
				trace("loading level");
				LevelIO.loadLevel(reloadLevel);
			} else if (e.keyCode == 80) {
				trace("saving level");
				LevelIO.saveLevel(level.recipe);
			}
        }
		    
        private function update(event:Event):void {
            for (var i:int = 0; i < level.dynamics.length; i++) {
                PhysicsHandler.gravitize(level.dynamics[i], level.walls, level.dynamics);
            }
            
            PhysicsHandler.handlePlayer(level.player, level.walls, level.dynamics)
        }
		
	}
	
}