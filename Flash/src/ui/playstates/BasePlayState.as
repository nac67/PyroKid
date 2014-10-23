package ui.playstates {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import pyrokid.Main;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class BasePlayState extends Sprite
	{
		private var listenersArray:Array = [];
		public var defaultBackground:Shape;
		
		public function BasePlayState() {
			//make white background by default
			defaultBackground = new Shape(); // initializing the variable named rectangle
			defaultBackground.graphics.beginFill(0xFFFFFF); // choosing the colour for the fill, here it is red
			defaultBackground.graphics.drawRect(0, 0, Main.MainStage.stageWidth,Main.MainStage.stageHeight); // (x spacing, y spacing, width, height)
			defaultBackground.graphics.endFill(); // not always needed but I like to put it in to end the fill
			addChild(defaultBackground); // adds the rectangle to the stage
			
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			listenersArray.push({type:type, listener:listener});
		}
		
		public function removeAllEventListeners():void {
		   for(var i:Number = 0; i<listenersArray.length; i++){
			  if(this.hasEventListener(listenersArray[i].type)){
				this.removeEventListener(listenersArray[i].type, listenersArray[i].listener);
			  }
		   }
		   listenersArray = null
		}
		
		public function addCenteredTextToScreen(text:String):void {
			var textToAdd:TextField = new TextField();
			textToAdd.width = Main.MainStage.stageWidth;
			textToAdd.height = Main.MainStage.stageHeight;
			textToAdd.text = String(text);
			textToAdd.y = Main.MainStage.stageHeight / 2 - textToAdd.textHeight / 2;
			
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.font = "Arial";
			format.size = 15;
			textToAdd.setTextFormat(format);
			
			addChild(textToAdd);
		}
		
	}

}