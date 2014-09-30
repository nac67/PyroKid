package pyrokid {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LevelEditorButton extends SimpleButton {
		private var upColor:uint = 0xFFCC00;
		private var overColor:uint = 0xCCFF00;
		private var downColor:uint = 0x00CCFF;

		public function LevelEditorButton(text:String, onClick:Function, x:int, y:int) {
			this.x = x;
			this.y = y;
			var w = 100;
			var h = 50;
			downState = new ButtonBackground(downColor, w, h, text);
			overState = new ButtonBackground(overColor, w, h, text);
			upState = new ButtonBackground(upColor, w, h, text);
			hitTestState = new ButtonBackground(upColor, w, h, text);
			useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onClick);
		}
	}
}