package ui.playstates {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import mx.core.ButtonAsset;
	import Main;
	import ui.ButtonBackground;
	import ui.buttons.ButtonBase;
    import ui.buttons.CoreButton;
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	public class BasePlayState extends Sprite
	{
		protected var listenersArray:Array = [];
		protected var buttonListenersDict:Dictionary = new Dictionary();
		protected var background:Shape;
        
        private var buttons:Array;
		
		public function BasePlayState(setBackground:Boolean = true) {
            if (setBackground) {
                addBackground(0x000000);
            }
            buttons = [];
		}
        
        public function destroy():void {
            for each (var button:CoreButton in buttons) {
                button.removeListeners();
            }
            Utils.removeAllChildren(this);
        }
        
        public function addCoreButton(button:CoreButton):void {
            addChild(button);
            buttons.push(button);
        }
        
        protected function addBackground(color:uint, alpha:Number = 1.0):void {
            background = new Shape();
            background.graphics.beginFill(color, alpha);
            background.graphics.drawRect(0, 0, Main.MainStage.stageWidth, Main.MainStage.stageHeight);
            background.graphics.endFill();
            addChild(background);
        }
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			listenersArray.push( { type:type, listener:listener } );
            trace("buttssssss");
		}
		
		public function removeAllEventListeners():void {
		   for(var i:Number = 0; i<listenersArray.length; i++){
			  if(this.hasEventListener(listenersArray[i].type)){
				this.removeEventListener(listenersArray[i].type, listenersArray[i].listener);
			  }
		   }
		   for (var key:* in buttonListenersDict) {
			if (buttonListenersDict[key] != undefined && key.hasEventListener(buttonListenersDict[key].type)) {
				key.removeEventListener(buttonListenersDict[key].type, buttonListenersDict[key].listener);
			}
		   }
		   
            for each (var button:CoreButton in buttons) {
                button.removeListeners();
            }
		   listenersArray = null;
		}
		
		public function addTextToScreen(text:String,w:int,h:int,x:int,y:int,format:TextFormat=null):void {
			var textToAdd:TextField = new TextField();
			textToAdd.width = w;
			textToAdd.height = h;
			textToAdd.text = String(text);
			textToAdd.y = y - h/2;
			textToAdd.x = x - w/2;
			
			if (format == null) {
				var format:TextFormat = new TextFormat();
				format.align = TextFormatAlign.CENTER;
				format.font = "Arial";
				format.size = 15;
				format.color = 0xFFFFFF;
			}
			textToAdd.setTextFormat(format);
			
			addChild(textToAdd);
		}
		
		protected function addButton(button:ButtonBase, fxn1:Function):void {
			addChild(button);
			
			var type1:String = MouseEvent.CLICK;
			button.addEventListener(type1, fxn1);
			
			buttonListenersDict[button] = { type:type1 , listener:fxn1 };
		}
		
	}

}