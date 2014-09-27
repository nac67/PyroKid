package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Main extends Sprite {
        
        private var level:Level;
        
        
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            Key.init(stage);
            
            level = new Level();
            level.reset();
            addChild(level);
            
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        private function update(event:Event):void {
            for (var i:int = 0; i < level.dynamics.length; i++) {
                PhysicsHandler.gravitize(level.dynamics[i], level.walls, level.dynamics);
            }
            
            PhysicsHandler.handlePlayer(level.player, level.walls, level.dynamics)
        }
    }

}