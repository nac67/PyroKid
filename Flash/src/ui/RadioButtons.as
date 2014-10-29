package ui {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class RadioButtons extends Sprite {
        private var buttonStart:Vector2i = new Vector2i(0, 0);
        private var buttonSize:Vector2i = new Vector2i(0, 0);
        private var buttons:Array = [];

        public var tintNormal:ColorTransform = new ColorTransform(0.7, 0.7, 0.7, 0.3, 0, 0, 0, 0);
        public var tintHighlight:ColorTransform = new ColorTransform(1, 1, 0.3, 1, 0, 0, 0, 0);
        public var tintSelected:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        
        private var selectedIndex:int = -1;
        private var onPress:Function;
        private var lock:Boolean = false;
        private var isHooked:Boolean = false;
        
        public function RadioButtons(bw:int, bh:int, fCallback:Function) {
            super();
            buttonSize.Set(bw, bh);
            addEventListener(Event.ADDED_TO_STAGE, init);
            onPress = fCallback;
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, dispose);
            hook();
        }
        private function dispose(e:Event = null):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
            addEventListener(Event.ADDED_TO_STAGE, init);
            unhook();
        }

        public function hook() {
            if (isHooked) return;
            isHooked = true;
            stage.addEventListener(MouseEvent.CLICK, onMouseClick);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        public function unhook() {
            if (!isHooked) return;
            isHooked = false;
            stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        public function lockUntilNext():void {
            lock = true;
        }
        
        private function onMouseMove(e:MouseEvent = null):void {
            highlightButton(e.stageX, e.stageY);
        }
        private function onMouseClick(e:MouseEvent = null):void {
            var buttonIndex = getPressedButton(e.stageX, e.stageY);
            onPress(this, buttonIndex);
        }
        
        public function addButton(o:DisplayObject):void {
            // Add To Buttons
            buttons.push(o);
            addChild(o);
            o.transform.colorTransform.color
            var s:Sprite;

            // Set Button Location And Size
            o.x = buttonStart.x;
            o.y = buttonStart.y;
            o.width = buttonSize.x;
            o.height = buttonSize.y;
            o.transform.colorTransform = tintNormal;
            
            // Move Location For Next Button
            buttonStart.y += buttonSize.y;
        }
        
        public function highlightButton(mx:Number, my:Number):int {
            var lastHit:int = -1;
            for (var i:int = 0; i < buttons.length; i++) {
                if (buttons[i].hitTestPoint(mx, my)) {
                    buttons[i].transform.colorTransform = tintHighlight;
                    lastHit = i;
                }
                else {
                    if (selectedIndex == i) {
                        buttons[i].transform.colorTransform = tintSelected;                        
                    }
                    else {
                        buttons[i].transform.colorTransform = tintNormal;                        
                    }
                }
            }
            return lastHit;
        }
        public function getPressedButton(mx:Number, my:Number):int {
            if (!lock) selectedIndex = -1;
            var ni:int = highlightButton(mx, my);
            if (lock && ni != -1) lock = false;
            if(!lock) selectedIndex = ni;
            return selectedIndex;
        }
    }

}