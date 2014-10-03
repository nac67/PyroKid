package pyrokid {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class SelectorButton extends Sprite {
		
		private var toggleChildren:Array;
		private var onSelectedChange:Function;
		private var selectedButton:LevelEditorButton;
		
		public function SelectorButton(options:Dictionary, onSelectedChange:Function):void {
			toggleChildren = [];
			this.onSelectedChange = onSelectedChange;
			var i:int = 0;
			for (var key:Object in options) {
				var value:String = options[key];
				var button:LevelEditorButton = new LevelEditorButton(null, 120, 20, 650, 200 + i * 20, value, value);
				button.setOnClick(getSelectorFunction(key, button));
				addChild(button);
				if (i == 0) {
					selectedButton = button;
					selectedButton.toggle();
				}
				i++;
			}
		}
		
		private function getSelectorFunction(id, button:LevelEditorButton):Function {
			return function():void {
				selectedButton.toggle();
				selectedButton = button;
				onSelectedChange(id);
			}
		}
		
	}
	
}