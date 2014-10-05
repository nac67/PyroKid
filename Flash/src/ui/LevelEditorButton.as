package ui {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LevelEditorButton extends SimpleButton {
		protected static var upColor:uint = 0x00CCFF;
		protected static var overColor:uint = 0xCCFF00;
		protected static var downColor:uint = 0xFFCC00;
		
		protected var mainText:String;
		protected var alternateText:String;
		protected var upC:uint;
		protected var downC:uint;
		protected var w:int;
		protected var h:int;
		
		private var isToggle:Boolean;

		public function LevelEditorButton(onClick:Function, w:int, h:int, x:int, y:int, text:String, altText:String = null) {
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			mainText = text;
			isToggle = altText != null;
			alternateText = isToggle ? altText : mainText;
			upC = upColor;
			downC = downColor;
			
			setBackgroundStates();
			hitTestState = upState;
			useHandCursor = true;
			setOnClick(onClick);
		}
		
		public function toggle():void {
			var temp = mainText;
			mainText = alternateText;
			alternateText = temp;
			
			var temp = upC;
			upC = downC;
			downC = temp;
			
			setBackgroundStates();
		}
		
		public function setOnClick(onClick:Function):void {
			if (onClick == null) {
				return;
			}
			if (isToggle) {
				addEventListener(MouseEvent.CLICK, function():void {
					toggle();
					onClick();
				});
			} else {
				addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		protected function setBackgroundStates():void {
			upState = new ButtonBackground(upC, w, h, mainText);
			downState = new ButtonBackground(downC, w, h, mainText);
			overState = new ButtonBackground(overColor, w, h, mainText);
		}
	}
}