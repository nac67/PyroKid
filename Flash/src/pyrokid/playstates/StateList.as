package pyrokid.playstates {
    import adobe.utils.CustomActions;
    import flash.display.Sprite;
    import flash.events.Event;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class StateList extends Sprite {
        private var currentState:ACPlayState = null;
        private var stateMap:Object = new Object();
        
        public function StateList(main:Sprite) {
            main.addChild(this);
            main.addEventListener(Event.ENTER_FRAME, update);
        }
        
        public function addState(name:String, state:ACPlayState):void {
            stateMap[name] = state;
        }
        public function start(state:String):void {
            // Make Sure To Exit The Current State
            if (currentState != null)
                currentState.setInactive(this);
            
            // Switch To A New State
            if (stateMap.hasOwnProperty(state))
                currentState = stateMap[state];
            else
                currentState = null;
                
            // Enter The New State
            if (currentState != null)
                currentState.setCurrent(this);
        }
        
        public function getState(state:String):ACPlayState {
            // Switch To A New State
            if (stateMap.hasOwnProperty(state))
                return stateMap[state];
            else
                return null;
        }
        
        public function update(e:Event = null):void {
            if (currentState != null) {
                currentState.updateLogic(this);
                currentState.updateVisuals(this);
                
                if (currentState.isFinished()) { 
                    var newState:String = currentState.getNextState();
                    if (newState == null) newState == "";
                    start(newState);
                }
                
                if (width != 0 && height != 0) {
                    trace("SL: " + x + "," + y);
                    trace("CS: " + currentState.x + "," + currentState.y);
                }
            }
        }
    }
}