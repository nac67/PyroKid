package ui {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ButtonBackground extends Sprite {

		public function ButtonBackground(color:int, w:int, h:int, text:String) {
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.appendText(text);
			textField.width = w;
			textField.height = h;
			addChild(textField);
			
			graphics.lineStyle(0x000000);
			graphics.beginFill(color);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
	}
}