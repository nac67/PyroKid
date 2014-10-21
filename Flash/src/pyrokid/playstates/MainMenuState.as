package pyrokid.playstates {
    import flash.utils.ByteArray;
    import flash.display.Sprite;
    import pyrokid.LevelRecipe;
    import pyrokid.MenuScreen;
    import Utils;
    import pyrokid.GameController;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class MainMenuState extends ACPlayState {
        
        override protected function onEntry(parent:StateList):void {
            // TODO: Add Buttons, etc.
        }
        override protected function onExit(parent:StateList):void {
            Utils.removeAllChildren(this);
        }
        
        override public function updateLogic(parent:StateList):void {
            var gamingState:GamingState = parent.getState("Gaming") as GamingState;
            
            // TODO: Set The Correct Level Recipe When It Is Selected
            
            moveToState("Gaming");
        }
        override public function updateVisuals(parent:StateList):void {
        }
    }

}