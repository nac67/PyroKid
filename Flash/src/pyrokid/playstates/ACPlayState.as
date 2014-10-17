package pyrokid.playstates {
    import flash.display.Sprite;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ACPlayState extends Sprite {
        private var isRunning:Boolean;
        private var desiredNextState:String;
        
        protected var parentList:StateList;
        
        protected function moveToState(state:String) {
            isRunning = false
            desiredNextState = state;
        }
        
        public function setCurrent(parent:StateList):void {
            parentList = parent;
            isRunning = true;
            parent.addChild(this);
            onEntry(parent);
        }
        public function setInactive(parent:StateList):void {
            isRunning = false;
            onExit(parent);
            parent.removeChild(this);
        }
        
        public function isFinished():Boolean {
            return !isRunning;
        }
        public function getNextState():String {
            return desiredNextState;
        }
        
        /**
         * Called When The State Becomes Active
         */
        protected /*ABSTRACT*/ function onEntry(parent:StateList):void {
            throw new Error("Implementation Of Abstract Method Required");
        }
        /**
         * Called When The State Becomes Inactive
         */
        protected /*ABSTRACT*/ function onExit(parent:StateList):void {
            throw new Error("Implementation Of Abstract Method Required");
        }
        
        /**
         * Frame-By-Frame Game Logic
         */
        public /*ABSTRACT*/ function updateLogic(parent:StateList):void {
            throw new Error("Implementation Of Abstract Method Required");
        }
        /**
         * Visual Updates Happen Here
         */
        public /*ABSTRACT*/ function updateVisuals(parent:StateList):void {
            throw new Error("Implementation Of Abstract Method Required");
        }
    }
}