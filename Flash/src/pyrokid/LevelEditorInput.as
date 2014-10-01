package pyrokid {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class LevelEditorInput extends Sprite {

		public function LevelEditorInput(label:String, content, x:int, y:int) {
			var input:TextField = new TextField();
			var name:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 20;
			input.defaultTextFormat = format;
			name.defaultTextFormat = format;
			
			input.border = true;
			input.width = 50;
			input.height = 25;
			input.x = x;
			input.y = y;
			input.type = TextFieldType.INPUT;
			input.maxChars = 3;
			input.restrict = "0-9";
			input.text = content;
			
			name.x = x + 50;
			name.y = y;
			name.text = label;
			
			addChild(input);
			addChild(name);
		}
	}
}