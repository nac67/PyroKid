package physics {
    
    /**
     * Collision Detection And Resolution Manager
     * @author Cristian Zaloj
     */
    public class CollisionResolver {
        public static function ConstructEdges(providers:Array):Array {
            var edges:Array = [];
            for (var y:int = 0; y < providers.length; y++) {
                for (var x:int = 0; x < providers[y].length; x++) {
                    if (providers[y][x] == null)
                        continue;
                    
                    providers[y][x].ProvideEdgesSpecial(edges);
                    
                    if (x == 0 || (providers[y][x - 1] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.NX, edges);
                    }
                    if (x == providers[y].length - 1 || (providers[y][x + 1] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.PX, edges);
                    }
                    if (y == 0 || (providers[y - 1][x] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.NY, edges);
                    }
                    if (y == providers.length - 1 || (providers[y + 1][x] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.PY, edges);
                    }
                }
            }
            return edges;
        }
        
        public static function Resolve(r:PhysRectangle, iList:Array, fCallback:Function):void {
            for each (var i:PhysIsland in iList) {
                // Move From Global To Island Reference Point
                r.center.SubV(i.globalAnchor);
                
                // Perform Collision Detection
                ResolveIsland(r, i.edges, fCallback);
                
                // Move Back In Global Frame Of Reference
                r.center.AddV(i.globalAnchor);
            }
        }
        private static function ResolveIsland(r:PhysRectangle, eList:Array, fCallback:Function):void {
            // Accumulate All Collisions
            var a:CollisionAccumulator = new CollisionAccumulator();
            for each (var e:PhysEdge in eList) {
                ResolveCollision(r, e, a);
            }
            
            // Use The Callback And Check If Resolution Should Continue
            var doResolve:Boolean = fCallback == null ? true : fCallback.call(r, a);
            
            // Resolve The Collision
            if (doResolve)
                r.center.Add(a.accumPX - a.accumNX, a.accumPY - a.accumNY);
        }
        private static function ResolveCollision(r:PhysRectangle, e:PhysEdge, a:CollisionAccumulator):void {
            switch (e.direction) {
                case Cardinal.NX: 
                    if (r.motion.x < 0)
                        break;
                    if (AreEdgesOverlapping(r.center.y, r.halfSize.y, e.center.y, e.halfSize)) {
                        if (r.PX > e.center.x)
                            a.accumNX = Math.max(a.accumNX, r.PX - e.center.x);
                    }
                    break;
                case Cardinal.PX: 
                    if (r.motion.x > 0)
                        break;
                    if (AreEdgesOverlapping(r.center.y, r.halfSize.y, e.center.y, e.halfSize)) {
                        if (r.NX < e.center.x)
                            a.accumPX = Math.max(a.accumPX, e.center.x - r.NX);
                    }
                    break;
                case Cardinal.NY: 
                    if (r.motion.y < 0)
                        break;
                    if (AreEdgesOverlapping(r.center.x, r.halfSize.x, e.center.x, e.halfSize)) {
                        if (r.PY > e.center.y)
                            a.accumNY = Math.max(a.accumNY, r.PY - e.center.y);
                    }
                    break;
                case Cardinal.PY: 
                    if (r.motion.y > 0)
                        break;
                    if (AreEdgesOverlapping(r.center.x, r.halfSize.x, e.center.x, e.halfSize)) {
                        if (r.NY < e.center.y)
                            a.accumPY = Math.max(a.accumPY, e.center.y - r.NY);
                    }
                    break;
            }
        }
        private static function AreEdgesOverlapping(c1:Number, hs1:Number, c2:Number, hs2:Number):Boolean {
            var d:Number = c2 > c1 ? c2 - c1 : c1 - c2;
            return d < (hs1 + hs2);
        }
    }
}