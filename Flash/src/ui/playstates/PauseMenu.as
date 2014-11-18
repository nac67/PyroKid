package ui.playstates {
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import pyrokid.GameController;
	import Main;
	import ui.buttons.MenuButton;
	import ui.LevelEditorButton;
    import flash.display.*;
    import flash.geom.*;
	import pyrokid.*;
	import ui.LevelsInfo;
    
	public class PauseMenu extends BasePlayState {
		
		private var game_controller:GameController;
		
		public function PauseMenu(game_contr:GameController) {
            super(false);
			game_controller = game_contr;
            
            addMinimap(game_contr.level);
			
			var pauseTextFormat:TextFormat = new TextFormat();
			pauseTextFormat.size = 40;
			pauseTextFormat.align = TextFormatAlign.CENTER;
			pauseTextFormat.font = "Impact";
			pauseTextFormat.color = 0xFFFFFF;
			addTextToScreen("Paused", 800, 100, 400, 70, pauseTextFormat);
			
            var buttonHeight:int = 526;
			addButton(new MenuButton("Resume", 100, buttonHeight), unpauseGame);
			addButton(new MenuButton("Restart", 300, buttonHeight), StateController.restartCurrLevel);
			addButton(new MenuButton("Levels", 500, buttonHeight), StateController.goToLevelSelectAtPage(LevelSelect.levelToPageNum(LevelsInfo.currLevel)));
			//addButton(new MenuButton("Options", 400,350), StateController.displayOptions);
			addButton(new MenuButton("Menu", 700, buttonHeight), StateController.goToMainMenu);
		}
        
        private function addMinimap(level:Level):void {
            var minimapBitmap:Bitmap = new Bitmap();
            var minimapBitmapData:BitmapData = new BitmapData(level.cellWidth * Constants.CELL, level.cellHeight * Constants.CELL);
            minimapBitmap.bitmapData = minimapBitmapData;
            
            minimapBitmap.scaleY = minimapBitmap.scaleX = 0.2;
            minimapBitmap.x = (Constants.WIDTH - minimapBitmap.width) / 2;
            minimapBitmap.y = (Constants.HEIGHT - minimapBitmap.height) / 2 - 20;
            minimapBitmapData.draw(level);
            addChild(minimapBitmap);
            
            var fadeOutOverlay:Sprite = new Sprite();
            for (var i:int = 0; i < 70; i++) {
                var lineWidth:int = 5;
                fadeOutOverlay.graphics.lineStyle(lineWidth, 0x000000, Math.min(1, 0.75 + i * 0.003), false, "normal", null, JointStyle.MITER);
                var distFromEdge:int = lineWidth / 2 + lineWidth * i;
                fadeOutOverlay.graphics.drawRect(
                    minimapBitmap.x - distFromEdge,
                    minimapBitmap.y - distFromEdge,
                    minimapBitmap.width + 2*distFromEdge,
                    minimapBitmap.height + 2*distFromEdge
                );
            }
            addChild(fadeOutOverlay);
        }
		
		private function unpauseGame(e:Event):void {
			removeAllEventListeners();
			Utils.removeAllChildren(this);
			game_controller.removeChild(this);
			game_controller.isPaused = false;
		}
		
		private function goToPreviousScreen(e:Event = null):Function {
			var self:BasePlayState = this;
			return function():void {
				StateController.removeOverlayedScreen(self);
			}
		}
	}

}