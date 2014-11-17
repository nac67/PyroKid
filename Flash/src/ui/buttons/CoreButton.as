package ui.buttons {
    import flash.display.*;
    import flash.events.Event;
    import flash.text.*;
    import ui.ButtonBackground;
    import pyrokid.Constants;
    import flash.events.MouseEvent;
    
    public class CoreButton extends SimpleButton {
        
		private var w:int;
		private var h:int;
        
        private var toggleState:int;
        private var stateChildren:Array;
        
        private var listener:Function;
        
        private var cornerSizeX:int = 18;
        private var cornerSizeY:int = 18;
        private var lineWidth:int = 3;
        
        /**
         * @param w width of button
         * @param h height of button
         * @param onClick function to be executed when the button is clicked. Takes no parameters and returns void.
         * @param ... buttonStatesContent The first argument provided here will be displayed on the button. If it is
         * a string, it will be displayed on the button as text. Otherwise it must be a display object. If more than
         * one argument is supplied, the button will toggle through all states when clicked.
         */
        public function CoreButton(w:int, h:int, onClick:Function, ... buttonStatesContent) {
            this.w = w;
            this.h = h;
            toggleState = 0;
            
            var hitBox:Sprite = new Sprite();
            hitBox.graphics.beginFill(0x000000);
            hitBox.graphics.drawRoundRect(0, 0, w, h, cornerSizeX, cornerSizeY);
            hitBox.graphics.endFill();
            hitTestState = hitBox;
            
			useHandCursor = true;
            visible = true;
            
            setButtonContent(buttonStatesContent);
            setOnClick(onClick);
            reset();
		}
        
        public function centerOn(x:int, y:int):CoreButton {
            this.x = x - w / 2;
            this.y = y - h / 2;
            return this;
        }
        
        public function setCorner(x:int, y:int):CoreButton {
            this.x = x;
            this.y = y;
            return this;
        }
        
        public function removeListeners():void {
            if (listener != null) {
                removeEventListener(MouseEvent.CLICK, listener);
            }
        }
        
        public function get numStates():int {
            return stateChildren[0].length;
        }
        
        public function getState():int {
            return toggleState;
        }
		
		public function reset():void {
            updateToggleState(0);
		}
        
		public function toggle():void {
            updateToggleState((toggleState + 1) % numStates);
		}
        
        
        // --------------------------- Helper methods ------------------------------ //
        
        private function updateToggleState(state:int):void {
            if (state < 0 || state >= numStates) {
                trace(Constants.ERROR_MESSAGE + "Button state out of bounds");
                return;
            }
            toggleState = state;
            
            upState = stateChildren[Constants.MOUSE_STATE_UP][toggleState];
            overState = stateChildren[Constants.MOUSE_STATE_OVER][toggleState];
            downState = stateChildren[Constants.MOUSE_STATE_DOWN][toggleState];
        }
		
		private function setOnClick(onClick:Function):void {
			if (onClick == null) {
				return;
			}
            
            listener = function(event:Event):void {
                toggle();
                onClick();
            };
            addEventListener(MouseEvent.CLICK, listener);
		}
        
        private function setButtonContent(statesContent:Array):void {
            stateChildren = new Array(Constants.MOUSE_STATES.length);
            for (var i:int = 0; i < stateChildren.length; i++) {
                stateChildren[i] = [];
            }
            
            for each (var content:Object in statesContent) {
                if (!(content is String || content is DisplayObject)) {
                    trace(Constants.ERROR_MESSAGE + "Button content must be Strings or DisplayObjects");
                    continue;
                }
                
                for each (var mouseState:int in Constants.MOUSE_STATES) {
                    var contentAsDisplayObj:DisplayObject;
                    if (content is String) {
                        // Create TextField from the content string
                        contentAsDisplayObj = getTextSprite(content as String);
                    } else {
                        // Duplicate the DisplayObject so it can be added to multiple states
                        var constr:Class = Object(content).constructor;
                        contentAsDisplayObj = new constr() as DisplayObject;
                        contentAsDisplayObj.scaleX = contentAsDisplayObj.scaleY = content.scaleX;
                        contentAsDisplayObj.x = w / 2;//(w - contentAsDisplayObj.width) / 2;
                        contentAsDisplayObj.y = h / 2;//(h - contentAsDisplayObj.height) / 2;
                    }
                    
                    var contentWithVisuals:DisplayObject = getBackground(contentAsDisplayObj, mouseState);
                    stateChildren[mouseState].push(contentWithVisuals);
                }
            }
        }
        
        private function getTextSprite(text:String):TextField {
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 20;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.font = "Impact";
			textFormat.color = 0xFFFFFF;
            
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.appendText(text);
			textField.width = w;
			textField.height = h;
            textField.setTextFormat(textFormat);
            
            textField.y += Math.round((textField.height - textField.textHeight) / 2) - 4;
            return textField;
        }
        
        private function getBackground(child:DisplayObject, mouseState:int):Sprite {
            var background:Sprite = new Sprite();
            if (mouseState != Constants.MOUSE_STATE_UP) {
                background.graphics.lineStyle(lineWidth, 0xFFFFFF, 1, true);
                
                if (mouseState == Constants.MOUSE_STATE_DOWN) {
                    background.graphics.beginFill(0xAF1616);
                    drawBorder(background);
                    background.graphics.endFill();
                } else {
                    drawBorder(background);
                }
            }
            background.addChild(child);
            return background;
        }
        
        private function drawBorder(background:Sprite):void {
            background.graphics.drawRoundRect(0, 0, w, h, cornerSizeX, cornerSizeY);
        }
    }
    
}