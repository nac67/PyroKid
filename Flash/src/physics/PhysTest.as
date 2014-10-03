package physics {
    import flash.display.SpreadMethod;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.ui.Keyboard;
    import pyrokid.Constants;
    import pyrokid.Key;
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public class PhysTest extends Sprite {
        private var world:Sprite = new Sprite();
        private var islandSprites:Array;
        private var player:Sprite = new Sprite();
        private var isPlayerGrounded:Boolean = false;
        
        private var islands:Array;
        private var rect:PhysRectangle;
        
        public function PhysTest() {
            super();
            
            addEventListener(Event.ADDED_TO_STAGE, Init);
        }
        
        public function Init(e:Event = null) {
            Key.init(stage);
            removeEventListener(Event.ADDED_TO_STAGE, Init);
            addEventListener(Event.ENTER_FRAME, Update);
            
            // Make Tiles Test
            var walls:Array = [
                [1, 1, 1, 1, 1, 1, 1, 1],
                [0, 0, 0, 1, 1, 0, 0, 0],
                [0, 0, 0, 0, 1, 0, 1, 0],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 0, 0]
            ];
            var tiles = new Array(7);
            for (var y:int = 0; y < 7; y++) {
                tiles[y] = new Array(8);
                for (var x:int = 0; x < 8; x++) {
                    switch (walls[y][x]) {
                        case 1: 
                            tiles[y][x] = new PhysBox();
                            break;
                        default: 
                            tiles[y][x] = null;
                            break;
                    }
                }
            }
            
            // Make Islands
            islands = IslandSimulator.ConstructIslands(tiles);
            islandSprites = new Array(islands.length);
            for each (var i:PhysIsland in islands) {
                var s:Sprite = new Sprite();
                s.graphics.beginFill(0xFF00FF, 1);
                for (var y:int = 0; y < i.tilesHeight; y++) {
                    for (var x:int = 0; x < i.tilesWidth; x++) {
                        if (i.tiles[y][x] != null) {
                            s.graphics.drawRect(x, y, 1, 1);
                        }
                    }
                }
                s.graphics.endFill();
                s.x = i.globalAnchor.x;
                s.y = i.globalAnchor.y;
                islandSprites.push(s);
                world.addChild(s);
            }
            
            // Make Player
            rect = new PhysRectangle();
            rect.halfSize.Set(0.4, 0.5);
            rect.center.Set(5, 5);
            rect.motion.Set(0, 0);
            
            player.graphics.beginFill(0xFF0000, 1);
            player.graphics.drawRect(-0.4, -0.5, 0.8, 1.0);
            player.graphics.endFill();
            world.addChild(player);
            player.x = 5;
            player.y = 5;
            
            addChild(world);
            world.width = 800 / 2;
            world.height = 700 / 2;
            world.scaleY *= -1;
            world.y = 400;
        }
        public function Update(e:Event = null) {
            var dt:Number = 1 / 30.0;
            rect.velocity.Add(0, -9 * dt);
            rect.velocity.x = 0;
            if (Key.isDown(Constants.LEFT_BTN)) {
                rect.velocity.x -= 2;
            } else if (Key.isDown(Constants.RIGHT_BTN)) {
                rect.velocity.x += 2;
            }
            if (isPlayerGrounded && Key.isDown(Constants.JUMP_BTN)) {
                rect.velocity.y = 5;
            }
            
            rect.Update(dt);
            isPlayerGrounded = false;
            
            CollisionResolver.Resolve(rect, islands, CR);
            
            player.x = rect.center.x;
            player.y = rect.center.y;
        }
        
        public function CR(r:PhysRectangle, a:CollisionAccumulator):Boolean {
            if (a.accumPY > 0)
                isPlayerGrounded = true;
            return true;
        }
    }
}