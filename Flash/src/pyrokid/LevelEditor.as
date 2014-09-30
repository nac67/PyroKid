package pyrokid {
    import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
    
    public class LevelEditor extends Sprite {
		
		private var level:Level;
        
        public function LevelEditor(level:Level):void {
			this.level = level;
			Main.MainStage.addEventListener(MouseEvent.CLICK, clickHandler);

			var button:LevelEditorButton = new LevelEditorButton("shwiggity", buttonify, 600, 50);
			addChild(button);
			var button2:LevelEditorButton = new LevelEditorButton("figgity", buttonify, 600, 150);
			addChild(button2);
		}
		
		private function buttonify(event:MouseEvent):void {
			trace("poooop");
		}
		
		public function turnEditorOff():void {
			Main.MainStage.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void {
			var cellX:int = event.stageX / Constants.CELL;
			var cellY:int = event.stageY / Constants.CELL;
			if (cellX >= level.walls.length || cellY >= level.walls[0].length) {
				return;
			}
			
			trace("stage x, y: " + cellX + ", " + cellY);
			var wallObj = level.getStaticObject(cellX, cellY);
			if (wallObj != null) {
				level.removeChild(wallObj);
			} else {
				var a:GroundTile = new GroundTile();
				a.x = cellX * Constants.CELL;
				a.y = cellY * Constants.CELL;
				level.addChild(a);
				level.setStaticObject(cellX, cellY, a);
			}
			toggleWall(cellX, cellY);
		}
		
		public function toggleWall(x:int, y:int):void {
			level.recipe.walls[x][y] = (level.recipe.walls[x][y] + 1) % 2;
			level.reset(level.recipe);
		}
    
    }

}