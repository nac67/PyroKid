package physics {
    import flash.accessibility.AccessibilityProperties;
    import flash.display.GraphicsPathWinding;
    import flash.geom.Point;
    import physics.Vector2i;
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public class IslandSimulator {
        /**
         * Construct Islands From A IPhysTile Level Input
         * @param tiles IPhysTile[y][x] Ordering
         * @return A List Of Islands
         */
        public static function ConstructIslands(tiles:Array):Array {
            var queue = [];
            var ids:Array = BuildIDs(tiles, queue);
            MergeIDs(tiles, ids, queue);
            var islandPositions:Array = GetIslandPositions(ids);
            
            var islands = new Array(islandPositions.length);
            for (var i:int = 0; i < islandPositions.length; i++) {
                islands[i] = ConstructIsland(islandPositions[i], tiles);
            }
            return islands;
        }
        
        private static function BuildIDs(tiles:Array, queue:Array):Array {
            var ids:Array = new Array(tiles.length);
            var uuid:int = 1;
            for (var y:int = 0; y < tiles.length; y++) {
                ids[y] = new Array(tiles[y].length);
                for (var x:int = 0; x < tiles[y].length; x++) {
                    var tile:IPhysTile = tiles[y][x];
                    if (tile == null) {
                        ids[y][x] = 0;
                    } else {
                        ids[y][x] = uuid;
                        queue.push(new Vector2i(x, y));
                        uuid++;
                    }
                }
            }
            return ids;
        }
        private static function MergeIDs(tiles:Array, ids:Array, queue:Array) {
            var h:int = tiles.length;
            var otherPos:Vector2i = new Vector2i(0, 0);
            while (queue.length > 0) {
                var pos:Vector2i = queue.shift();
                var w:int = tiles[pos.y].length;
                
                // Merge In Four Directions
                if (pos.x > 0)
                    MergeTiles(tiles, ids, pos, (otherPos.SetV(pos)).Sub(1, 0), Cardinal.NX);
                if (pos.x < w - 1)
                    MergeTiles(tiles, ids, pos, (otherPos.SetV(pos)).Add(1, 0), Cardinal.PX);
                if (pos.y > 0)
                    MergeTiles(tiles, ids, pos, (otherPos.SetV(pos)).Sub(0, 1), Cardinal.NY);
                if (pos.y < h - 1)
                    MergeTiles(tiles, ids, pos, (otherPos.SetV(pos)).Add(0, 1), Cardinal.PY);
            }
        }
        private static function MergeTiles(tiles:Array, ids:Array, p1:Vector2i, p2:Vector2i, dir12:int) {
            var t1:IPhysTile = tiles[p1.y][p1.x];
            var id1:int = ids[p1.y][p1.x];
            var t2:IPhysTile = tiles[p2.y][p2.x];
            var id2:int = ids[p2.y][p2.x];
            
            // Check For Abscence And Merge History
            if (t1 == null || t2 == null)
                return;
            if (id1 == id2)
                return;
            
            // Check If They Can Bind In Both Directions
            if (t1.CanBind(dir12,t2) && t2.CanBind(dir12 ^ 1,t1)) {
                // Set To The Minimum ID
                if (id1 < id2)
                    SwapIDs(ids, p2.x, p2.y, id2, id1);
                else
                    SwapIDs(ids, p1.x, p1.y, id1, id2);
            }
            return;
        }
        private static function SwapIDs(ids:Array, x:int, y:int, idRef:int, idSwap:int) {
            if (ids[y][x] == idRef) {
                ids[y][x] = idSwap;
                
                var h:int = ids.length;
                var w:int = ids[y].length;
                
                if (x > 0)
                    SwapIDs(ids, x - 1, y, idRef, idSwap);
                if (x < w - 1)
                    SwapIDs(ids, x + 1, y, idRef, idSwap);
                if (y > 0)
                    SwapIDs(ids, x, y - 1, idRef, idSwap);
                if (y < h - 1)
                    SwapIDs(ids, x, y + 1, idRef, idSwap);
            }
        }
        private static function GetIslandPositions(ids:Array):Array {
            var map:Object = new Object();
            var islandPositions = [];
            
            for (var y:int = 0; y < ids.length; y++) {
                for (var x:int = 0; x < ids[y].length; x++) {
                    var id:int = ids[y][x];
                    
                    // Skip If Nothing
                    if (id == 0)
                        continue;
                    
                    var idS:String = id.toString();
                    if (!map.hasOwnProperty(idS)) {
                        // Create A New Position Set
                        var newIsland:Array = [];
                        map[idS] = newIsland;
                        islandPositions.push(newIsland);
                    }
                    
                    // Add Position To Island
                    map[idS].push(new Vector2i(x, y));
                }
            }
            
            return islandPositions;
        }
        private static function ConstructIsland(pos:Array, tiles:Array):PhysIsland {
            var xBounds:Vector2i = new Vector2i(int.MAX_VALUE, int.MIN_VALUE);
            var yBounds:Vector2i = new Vector2i(int.MAX_VALUE, int.MIN_VALUE);
            
            for each (var p:Vector2i in pos) {
                if (p.x < xBounds.x)
                    xBounds.x = p.x;
                if (p.x > xBounds.y)
                    xBounds.y = p.x;
                if (p.y < yBounds.x)
                    yBounds.x = p.y;
                if (p.y > yBounds.y)
                    yBounds.y = p.y;
            }
            
            // Create Island At Its Starting Min Location
            var island:PhysIsland = new PhysIsland(xBounds.y - xBounds.x + 1, yBounds.y - yBounds.x + 1);
            island.globalAnchor.Set(xBounds.x, yBounds.x);
            
            // Add All The Tiles
            for each (var p:Vector2i in pos) {
                var tile:IPhysTile = tiles[p.y][p.x];
                p.Sub(xBounds.x, yBounds.x);
                island.AddTile(p.x, p.y, tile);
            }
            
            // Construct Edges
            island.RebuildEdges();
            return island;
        }
    
    }
}