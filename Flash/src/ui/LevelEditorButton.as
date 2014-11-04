package ui {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LevelEditorButton extends SimpleButton {
		public static var upColor:uint = 0x00CCFF;
		public static var overColor:uint = 0xCCFF00;
		public static var downColor:uint = 0xFFCC00;
		
		private var texts:Array;
		private var colors:Array;
		private var toggleState:int;
		
		protected var w:int;
		protected var h:int;
		
		private var isToggle:Boolean;

		public function LevelEditorButton(onClick:Function, w:int, h:int, x:int, y:int, texts:Array, colors:Array) {
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
			this.texts = texts;
			this.colors = colors;
			toggleState = 0;
			isToggle = texts.length > 1;
			
			setBackgroundStates();
			hitTestState = upState;
			useHandCursor = true;
			setOnClick(onClick);
		}
		
		public function reset():void {
			toggleState = 0;
			setBackgroundStates();
		}
		
		public function toggle():void {
			toggleState = (toggleState + 1) % texts.length;
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
			upState = new ButtonBackground(colors[toggleState], w, h, texts[toggleState]);
			downState = new ButtonBackground(downColor, w, h, texts[toggleState]);
			overState = new ButtonBackground(overColor, w, h, texts[toggleState]);
		}
	}
}