package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
    import flash.events.KeyboardEvent;
	import physics.*;
	
	public class GameController extends Sprite {
		
        public var editorMode:Boolean = false;
		private var levelEditor:LevelEditor;
        
		public var level:Level;
		
		// TODO remove
        private var isPlayerGrounded:Boolean = false;
		
		public function GameController() {
			Main.MainStage.addEventListener(KeyboardEvent.KEY_UP, levelEditorListener);
            LevelIO.loadLevel(function(levelRecipe):void {
				reloadLevel(levelRecipe);
				levelEditor = new LevelEditor(level);
				addChild(levelEditor);
				addEventListener(Event.ENTER_FRAME, update);
			});
		}

		public function reloadLevel(levelRecipe):void {
			if (level != null) {
				removeChild(level);
			}
			level = new Level(levelRecipe);
			addChild(level);
			if (editorMode) {
				levelEditor.loadLevel(level);
			}
		}
		
		private function levelEditorListener(e:KeyboardEvent):void {
            if (e.keyCode == 13) { //enter
                editorMode = !editorMode;
				if (editorMode) {
					levelEditor.turnEditorOn();
				} else {
					levelEditor.turnEditorOff();
				}
                reloadLevel(level.recipe);
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
		
        public function CR(r:GameEntity, a:CollisionAccumulator):Boolean {
            if (a.accumNY > 0)
                isPlayerGrounded = true;
            return true;
        }
		    
        private function update(event:Event):void {
			if (!editorMode) {
				level.x = - level.player.x + 400;
				
				var dt:Number = 1 / 30.0;
				level.player.velocity.Add(0, 9 * dt);
				level.player.velocity.x = 0;
				if (Key.isDown(Constants.LEFT_BTN)) {
					level.player.velocity.x -= 2;
				} else if (Key.isDown(Constants.RIGHT_BTN)) {
					level.player.velocity.x += 2;
				}
				if (isPlayerGrounded && Key.isDown(Constants.JUMP_BTN)) {
					level.player.velocity.y = -6;
				}
				level.player.Update(dt);
				isPlayerGrounded = false;
				CollisionResolver.Resolve(level.player, level.islands, CR);
            }
        }
		
	}
	
}