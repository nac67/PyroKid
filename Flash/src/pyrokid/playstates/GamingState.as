package pyrokid.playstates {
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.utils.ByteArray;
    import pyrokid.GameController;
    import pyrokid.LevelRecipe;
    import pyrokid.tools.Key;
    import pyrokid.tools.Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class GamingState extends ACPlayState {
        public var levelRecipe:ByteArray = null;
        private var game:GameController;
        
        override protected function onEntry(parent:StateList):void {
            game = new GameController();
            addChild(game);
            game.init(levelRecipe);
            
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
        override protected function onExit(parent:StateList):void {
            stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            game.destroy();
            game = null;
            levelRecipe = null;
            Utils.removeAllChildren(this);
        }
        
        override public function updateLogic(parent:StateList):void {
            if (game.isGameOver) {
                moveToState("Main Menu");
            }
        }
        override public function updateVisuals(parent:StateList):void {
        }
        
        private function onKeyUp(e:KeyboardEvent = null) {
            if (e.keyCode == Key.ENTER) {
                moveToState("Editor");
            }
        }
    }

}