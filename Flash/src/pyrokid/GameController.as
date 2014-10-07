package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class GameController extends Sprite {
		
        public var editorMode:Boolean = false;
		private var levelEditor:LevelEditor;
        
		public var level:Level;
		
		public var isGameOver:Boolean = false;
		public var createGameOverScreenFunc:Function;
		
		public function GameController() {
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            
            level = new Level(new LevelRecipe());
            addChild(level);
            addEventListener(Event.ENTER_FRAME, update);
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);
		}

		public function reloadLevel(levelRecipe):void {
			removeChild(level);
			level = new Level(levelRecipe);
			addChild(level);
		}
		
		private function levelEditorListener(e:KeyboardEvent):void {
            if (e.keyCode == 13) { //enter
                editorMode = !editorMode;
                reloadLevel(level.recipe);
				if (editorMode) {
					levelEditor = new LevelEditor(level);
					addChild(levelEditor);
				} else {
					levelEditor.turnEditorOff();
					removeChild(levelEditor);
				}
            }
            
            if (editorMode){
                if (e.keyCode == 79) { //o
                    trace("loading level");
                    LevelIO.loadLevel(reloadLevel);
                } else if (e.keyCode == 80) { //p
                    trace("saving level");
                    LevelIO.saveLevel(level.recipe);
                }
            } else { 
                
            }
        }
		
		private function keyboardActionListener(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE) {
				isGameOver = true;
				createGameOverScreenFunc(false);
				trace("over");
				Main.MainStage.removeEventListener(KeyboardEvent.KEY_UP, keyboardActionListener);

			}
		}
		    
        private function update(event:Event):void {
            if(!editorMode){
                for (var i:int = 0; i < level.crates.length; i++) {
                    PhysicsHandler.gravitize(level.crates[i], level.walls, level.crates);
                }
                
                PhysicsHandler.handlePlayer(level.player, level.walls, level.crates)
            }
        }
		
	}
	
}