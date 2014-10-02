package physics {
	import flash.display.Sprite;
    import flash.events.Event;
	
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysTest extends Sprite {
        private var player:Sprite = new Sprite();
        
        private var edges:Array;
        
        
        public function PhysTest() {
            super();
            addEventListener(Event.ENTER_FRAME, Update);
            
            var testBoxes:Array = [
                [null, null, null, null, null],
                [null, null, null, null, null],
                [null, null, null, null, null],
                [null, null, null, null, null],
                [null, null, null, null, null]
            ];
            testBoxes[4][0] = new PhysBox(1, 0, 0);
            testBoxes[4][1] = new PhysBox(1, 1, 0);
            testBoxes[4][2] = new PhysBox(1, 2, 0);
            testBoxes[4][3] = new PhysBox(1, 3, 0);
            testBoxes[4][4] = new PhysBox(1, 4, 0);
            
            addEventListener(Event.ADDED_TO_STAGE, Init);
        }
        
        public function Init(e:Event = null) {
            removeEventListener(Event.ADDED_TO_STAGE, Init);
            
            graphics.drawRect(0, 0, 5, 1);
        }
        public function Update(e:Event = null) {
            
        }
    }

}