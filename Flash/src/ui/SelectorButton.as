package ui {
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
            
            var keys:Array = [];
            for (var key:Object in options) {
                keys.push(key);
            }
            keys.sort();
            
			for (var i = 0; i < keys.length; i++) {
                var key = keys[i];
				var value:String = options[key];
				var button:LevelEditorButton = new LevelEditorButton(null, 120, 20, 650, 200 + i * 20, [value, value], [LevelEditorButton.upColor, 0xFF0000]);
				button.setOnClick(getSelectorFunction(key, button));
				addChild(button);
				if (i == 0) {
					selectedButton = button;
					selectedButton.toggle();
				}
			}
		}
		
		private function getSelectorFunction(id:Object, button:LevelEditorButton):Function {
			return function():void {
				selectedButton.toggle();
				selectedButton = button;
				onSelectedChange(id);
			}
		}
		
	}
	
}