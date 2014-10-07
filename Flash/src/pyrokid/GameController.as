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
		
		// TODO reset to 0 when level editor turned off
		private var frameCount:int = 0;
		
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
		
        public function CR(r:PhysRectangle, a:CollisionAccumulator):Boolean {
            if (a.accumNY > 0)
                isPlayerGrounded = true;
            return true;
        }
		    
        private function update(event:Event):void {
			if (editorMode) {
				return;
			}
			frameCount += 1;
			
			var dt:Number = 1 / 30.0;
			level.playerRect.velocity.Add(0, 9 * dt);
			level.playerRect.velocity.x = 0;
			if (Key.isDown(Constants.LEFT_BTN)) {
				level.playerRect.velocity.x -= 2;
			} else if (Key.isDown(Constants.RIGHT_BTN)) {
				level.playerRect.velocity.x += 2;
			}
			if (isPlayerGrounded && Key.isDown(Constants.JUMP_BTN)) {
				level.playerRect.velocity.y = -6;
                var rIsland:int = int(Math.random() * level.islands.length);
                var island:PhysIsland = level.islands[rIsland];
                var rX:int = int(Math.random() * island.tilesWidth);
                var rY:int = int(Math.random() * island.tilesHeight);
                level.destroyTile(island, rX, rY);
			}
			isPlayerGrounded = false;
			
            
			ViewPIsland.updatePhysics(level.islands, level.columns, new Vector2(0, 9), dt);
			for (var i:int = 0; i < level.islandViews.length; i++) {
				level.islandViews[i].onUpdate();
			}
			for (var i:int = 0; i < level.rectViews.length; i++) {
				level.rectViews[i].onUpdate(level.islands, dt, CR);
			}
			
			
			if (frameCount % 30 == 0) {
				FireHandler.spreadFire(level.onFire, level.tileEntityGrid, frameCount);
			}
			level.x = Math.floor(level.x * Constants.CAMERA_LAG + (1 - Constants.CAMERA_LAG) * (-level.player.x + 400));
			level.y = Math.floor(level.y * Constants.CAMERA_LAG + (1 - Constants.CAMERA_LAG) * (-level.player.y + 300));
        }
		
	}
	
}