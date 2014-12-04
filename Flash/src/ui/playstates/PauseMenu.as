package ui.playstates {
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import pyrokid.GameController;
	import Main;
    import ui.buttons.CoreButton;
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
            
            createButtonDefaultSize(unpauseGame, "Resume").centerOn(100, buttonHeight);
            createButtonDefaultSize(StateController.restartCurrLevel, "Restart").centerOn(300, buttonHeight);
            createButtonDefaultSize(StateController.goToLevelSelectAtPage(LevelSelect.levelToPageNum(LevelsInfo.currLevel)), "Levels").centerOn(500, buttonHeight);
            createReturnToMainMenuButton().centerOn(700, buttonHeight);
            
            //StateController.displayOptions(true, Constants.BUTTON_PADDING, Constants.BUTTON_PADDING);
			var options:OptionsMenu = new OptionsMenu(true, Constants.BUTTON_PADDING, Constants.BUTTON_PADDING);
			options.y = 200;
            addChild(options);
		}
        
        private function addMinimap(level:Level):void {
            var minimapBitmap:Bitmap = Utils.generateMinimap(level);
			
			var widthRatio:Number = 500 / minimapBitmap.width;
			var heightRatio:Number = 400 / minimapBitmap.height;
			var ratio:Number = Math.min(widthRatio, heightRatio);
			
            minimapBitmap.scaleY = minimapBitmap.scaleX = ratio;
            minimapBitmap.x = 100 + (Constants.WIDTH - minimapBitmap.width) / 2;
            minimapBitmap.y = (Constants.HEIGHT - minimapBitmap.height) / 2 - 20;
            addChild(minimapBitmap);
            
            var fadeOutOverlay:Sprite = new Sprite();
            for (var i:int = 0; i < 100; i++) {
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
        
        
		
		private function unpauseGame(e:Event = null):void {
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