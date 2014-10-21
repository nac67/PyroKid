package pyrokid.playstates {
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.utils.ByteArray;
    import pyrokid.CaveBackground;
    import pyrokid.Level;
    import pyrokid.LevelEditor;
    import pyrokid.LevelIO;
    import pyrokid.LevelRecipe;
    import pyrokid.tools.Key;
    import Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class LevelEditorState extends ACPlayState {
        private var editor:LevelEditor;
        
        override protected function onEntry(parent:StateList):void {
            var level:Level = new Level(LevelRecipe.generateTemplate(15, 10));
            editor = new LevelEditor(level);
            addChild(editor);
            editor.hookEvents();
            
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
        override protected function onExit(parent:StateList):void {
            stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            editor.unhookEvents();
            Utils.removeAllChildren(this);
        }
        
        override public function updateLogic(parent:StateList):void {
        }
        override public function updateVisuals(parent:StateList):void {
        }
        
        private function onKeyUp(e:KeyboardEvent = null):void {
            // TODO: When Done Go To The Gaming State
            switch(e.keyCode) {
                case Key.ENTER:
                    var gamingState:GamingState = parentList.getState("Gaming") as GamingState;
                    gamingState.levelRecipe = new ByteArray();
                    gamingState.levelRecipe.writeObject(editor.getRecipe());
                    moveToState("Gaming");
                    break;
                case 79:
                    trace("loading level");
                    LevelIO.loadLevel(reloadLevel);
                    break;
                case 80:
                    trace("saving level");
                    LevelIO.saveLevel(editor.getRecipe());
                    break;
            }
        }
        
        public function reloadLevel(levelRecipe:Object):void {
            var level:Level = new Level(levelRecipe);
            editor.loadLevel(level);
        }
    }

}