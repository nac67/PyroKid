package pyrokid.dev {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import pyrokid.Connector;
    import pyrokid.Constants;
    import pyrokid.Level;
    import pyrokid.tools.Camera;
    import ui.RadioButtons;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class LevelEditor extends Sprite {
        // Embedded Tabs
        [Embed(source="Tiles.png")]
        public static var Button1:Class;
        [Embed(source="Clumping.png")]
        public static var Button2:Class;
        [Embed(source="Connecting.png")]
        public static var Button3:Class;
        [Embed(source="Camera.png")]
        public static var Button4:Class;
        
        private var tabs:RadioButtons = new RadioButtons(64, 64, onButtonPress);
        //private var editors:Array = [];
        private var currentEditor:ACLevelEditorController = null;
        
        public function LevelEditor(l:Level) {
            super();
            addEventListener(Event.ADDED_TO_STAGE, init);

            editors.push(new LECTile(l));
            editors.push(new LECClumping(l));
            editors.push(new LECConnecting(l));
            editors.push(new LECCamera(l));
            
            renderSelf();
        }
        private function renderSelf():void {
            tabs.addButton(new Button1() as Bitmap);
            tabs.addButton(new Button2() as Bitmap);
            tabs.addButton(new Button3() as Bitmap);
            tabs.addButton(new Button4() as Bitmap);
            tabs.x = Constants.WIDTH - 64;
            tabs.y = 0;
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, dispose);

            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            addChild(tabs);
            visible = false;
            tabs.unhook();
        }
        private function dispose(e:Event = null):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
            addEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            removeChild(tabs);
        }
        
        private function onButtonPress(o:RadioButtons, i:int):void {
            setController(i);
            tabs.lockUntilNext();
        }
        
        private function setController(i:int):void {
            if (currentEditor != null) {
                if (!visible) currentEditor.unhookLogic();
                removeChild(currentEditor);
                currentEditor = null;
            }
            
            if (i >= 0 && i < editors.length) {
                currentEditor = editors[i];
                addChild(currentEditor);
                if (!visible) currentEditor.hookLogic();
            }
        }
        
        private function onKeyDown(e:KeyboardEvent = null):void {
            switch(e.keyCode) {
                case Keyboard.ESCAPE:
                case Keyboard.ENTER:
                    parent.removeChild(this);
                    break;
                case Keyboard.E:
                    visible = true;
                    tabs.hook();
                    if (currentEditor != null)
                        currentEditor.unhookLogic();
                    break;
            }
        }
        private function onKeyUp(e:KeyboardEvent = null):void {
            switch(e.keyCode) {
                case Keyboard.E:
                    visible = false;
                    tabs.unhook();
                    if (currentEditor != null)
                        currentEditor.hookLogic();
                    break;
            }
        }
        
        
    }

}