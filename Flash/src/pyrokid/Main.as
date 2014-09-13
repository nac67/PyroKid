package pyrokid {
    import flash.display.Sprite;
    import flash.events.Event;
    
    /**
     * ...
     * @author Nick Cheng
     */
    public class Main extends Sprite {
        
        private var player:Player;
        
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
            
            for (var i:int = 0; i < Level.level1.length; i++) {
                var row:Array = Level.level1[i];
                for (var j:int = 0; j < row.length; j++) {
                    var cell:int = row[j];
                    if (cell == 1) {
                        var a:GroundTile = new GroundTile();
                        a.x = j * Constants.CELL;
                        a.y = i * Constants.CELL;
                        addChild(a);
                    }
                }
            }
            
            player = new Player();
            player.x = 2 * Constants.CELL;
            player.y = 2 * Constants.CELL;
            addChild(player);
            
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        private function update(event:Event):void {
            PhysicsHandler.handlePlayer(player, Level.level1)
        }
    }

}