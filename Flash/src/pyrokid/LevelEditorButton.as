package pyrokid {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LevelEditorButton extends SimpleButton {
		private static var upColor:uint = 0x00CCFF;
		private static var overColor:uint = 0xCCFF00;
		private static var downColor:uint = 0xFFCC00;

		public function LevelEditorButton(text:String, onClick:Function, w:int, h:int, x:int, y:int) {
			this.x = x;
			this.y = y;
			downState = new ButtonBackground(downColor, w, h, text);
			overState = new ButtonBackground(overColor, w, h, text);
			upState = new ButtonBackground(upColor, w, h, text);
			hitTestState = upState;
			useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onClick);
		}
	}
}