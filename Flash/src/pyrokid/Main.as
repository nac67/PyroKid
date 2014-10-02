package pyrokid {
    import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;
    import physics.PhysBox;
    import physics.PhysEdge;
    import physics.PhysIsland;
    import physics.PhysRectangle;
    import physics.CollisionResolver;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Main extends Sprite {
		
		public static var MainStage:Stage;
        
        private var pr:PhysRectangle = new PhysRectangle();
        private var pi:PhysIsland = new PhysIsland(10, 10);
        
        public function Main():void {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            for (var i:int  = 0; i < 10; i++) {
                pi.AddFullBlock(i, 0);
            }
            pi.RebuildEdges();
            pr.center.Set(0, 30.0);
            pr.motion.Set(0, -9.0);
            
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.ENTER_FRAME, Update);
            // entry point
			MainStage = stage;
            Key.init(stage);
			addChild(new GameController());
        }
		private function Update(e:Event = null):void {
                pr.center.y += pr.motion.y / 30.0;
                
                CollisionResolver.Resolve(pr, [pi], null);
                trace(pr.center.y);
        }
    }

}