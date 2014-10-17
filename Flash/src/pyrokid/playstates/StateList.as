package pyrokid.playstates {
    import adobe.utils.CustomActions;
    import flash.display.Sprite;
    import flash.events.Event;
	/**
     * Contains And Controls A List Of Runnabl States
     * @author Cristian Zaloj
     */
    public class StateList extends Sprite {
        /**
         * The Active Running State
         */
        private var currentState:ACPlayState = null;
        /**
         * Dictionary Of States Referenced By String Names
         */
        private var stateMap:Object = new Object();
        
        /**
         * Creates A Blank List Of States And Attaches Itself Onto The Parent Sprite
         * @param main The Location To Attach All The Runnable States
         */
        public function StateList(main:Sprite) {
            main.addChild(this);
            main.addEventListener(Event.ENTER_FRAME, update);
        }
        
        /**
         * Add A State To This List
         * @param name The Identifier For This State
         * @param state The State Object
         */
        public function addState(name:String, state:ACPlayState):void {
            stateMap[name] = state;
        }
        /**
         * Start Up The Controller At A Designated State
         * @param state The Name Of The State
         */
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
        /**
         * Attempt To Retrieve A Stored State
         * @param state The Identifier For This State
         * @return State or null If It Cannot Be Found
         */
        public function getState(state:String):ACPlayState {
            // Switch To A New State
            if (stateMap.hasOwnProperty(state))
                return stateMap[state];
            else
                return null;
        }
        
        /**
         * State Control Code
         * @param e Not Used
         */
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