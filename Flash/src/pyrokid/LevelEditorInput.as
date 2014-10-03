package pyrokid {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class LevelEditorInput extends Sprite {
		
		private var input:TextField;
		private var onUpdate:Function;
		private var storedValue:int;
		
		private var poop:int;

		public function LevelEditorInput(label:String, content:int, x:int, y:int, onUpdate:Function) {
			this.input = new TextField();
			this.onUpdate = onUpdate;
			this.storedValue = int(content);
			
			var format:TextFormat = new TextFormat();
			format.size = 20;
			input.defaultTextFormat = format;
			
			input.border = true;
			input.width = 50;
			input.height = 25;
			input.x = x;
			input.y = y;
			input.type = TextFieldType.INPUT;
			input.maxChars = 3;
			input.restrict = "0-9";
			input.text = String(content);
			
			var confirm:LevelEditorButton = new LevelEditorButton(updateOnValue, 70, 25, x + 50, y, label);

			addChild(input);
			addChild(confirm);

			input.addEventListener(FocusEvent.FOCUS_IN, enterFocus);
			input.addEventListener(FocusEvent.FOCUS_OUT, exitFocus);
		}
		
		
		private function updateOnValue(event:MouseEvent):void {
			onUpdate(input.text);
		}
		
		private function enterFocus(event:FocusEvent):void {
			//trace("confirm has focus.");
		}

		private function exitFocus(event:FocusEvent):void {
			//input.text = String(storedValue);
		}
	}
}