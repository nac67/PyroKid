package physics {
    
    /**
     * Collision Detection And Resolution Manager
     * @author Cristian Zaloj
     */
    public class CollisionResolver {
        /**
         * If An Object Moves More Than This Amount In A Single Step, Shit Will Get Shat
         */
        public static var MAX_MOTION:Number = 0.2;
        /**
         * A Utility Used Upon Motion Values To Ensure Your Game Runs Without A Glitch
         * @param v Displacement Amount Desired In A Frame
         * @return A Displacement That Physics Engine Likes
         */
        public static function ClampedMotion(v:Number):Number {
            if (v < -MAX_MOTION) return -MAX_MOTION;
            if (v > MAX_MOTION) return MAX_MOTION;
            return v;
        }
        
        /**
         * Construct A Set Of Edges In The Frame Of Reference Of The Island
         * @param providers IPhysTile[y][x] Array
         * @return A Set Of Collision Edges
         */
        public static function ConstructEdges(providers:Array):Array {
            var edges:Array = [];
            var offset:Vector2 = new Vector2(0, 0);
            for (var y:int = 0; y < providers.length; y++) {
                for (var x:int = 0; x < providers[y].length; x++) {
                    if (providers[y][x] == null)
                        continue;
                    offset.Set(x, y);
                    
                    providers[y][x].ProvideEdgesSpecial(edges, offset);
                    
                    if (x == 0 || (providers[y][x - 1] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.NX, edges, offset);
                    }
                    if (x == providers[y].length - 1 || (providers[y][x + 1] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.PX, edges, offset);
                    }
                    if (y == 0 || (providers[y - 1][x] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.NY, edges, offset);
                    }
                    if (y == providers.length - 1 || (providers[y + 1][x] == null)) {
                        providers[y][x].ProvideEdgesDirection(Cardinal.PY, edges, offset);
                    }
                }
            }
            return edges;
        }
        
        public static function BuildTrimmedEdgeSet(islands:Array, clipDist:Number) {            
            
            // Separate Island Types
            var clipIslands:Array = [];
            var staticIslands:Array = [];
            for each(var i:PhysIsland in islands) {
                if (i.isGrounded) staticIslands.push(i);
                else clipIslands.push(i);
            }
            
            
            var cedges:Array = [[], [], [], []];
            for each(var i:PhysIsland in islands) {
                i.clippedEdges = new Array(i.edges.length);
                var ei:int = 0;
                for each(var e:PhysEdge in i.edges) {
                    var ce:PhysEdge = e.Clone(i.globalAnchor);
                    cedges[ce.direction].push(ce);
                    i.clippedEdges[ei++] = ce;
                }
            }
            for each(var ce:PhysEdge in cedges[Cardinal.NX]) {
                for each(var se:PhysEdge in cedges[Cardinal.PX]) {
                    if (ce.direction == -1 || se.direction == -1) continue;
                    ClipX(ce, se, clipDist);
                }
            }
            for each(var ce:PhysEdge in cedges[Cardinal.NY]) {
                for each(var se:PhysEdge in cedges[Cardinal.PY]) {
                    if (ce.direction == -1 || se.direction == -1) continue;
                    ClipY(ce, se, clipDist);
                }
            }
            
            // Position Back To Island Frame
            for each(var i:PhysIsland in islands) {
                for each(var e:PhysEdge in i.clippedEdges) {
                    e.center.SubV(i.globalAnchor);
                }
            }
        }
        private static function ClipX(ce:PhysEdge, se:PhysEdge, clipDist:Number) {
            if (ce.halfSize > se.halfSize) ClipX(se, ce, clipDist);
            
            // Check For Neighboring
            var d:Number = ce.center.x - se.center.x;
            if (Math.abs(d) > clipDist) return;

            // Check If They Clip
            var off = ce.center.y - se.center.y;
            if (Math.abs(off) >= (ce.halfSize + se.halfSize)) return;
            
            ce.halfSize = Math.abs(off) - se.halfSize;
            if (ce.halfSize <= 0) {
                ce.direction = -1;
                se.direction = -1;
                // TODO: Split In Two
                return;
            }
            if (off > 0)
                ce.center.y = se.center.y + se.halfSize + ce.halfSize;
            else
                ce.center.y = se.center.y - se.halfSize - ce.halfSize;
        }
        private static function ClipY(ce:PhysEdge, se:PhysEdge, clipDist:Number) {
            if (ce.halfSize > se.halfSize) ClipY(se, ce, clipDist);
            
            // Check For Neighboring
            var d:Number = ce.center.y - se.center.y;
            if (Math.abs(d) > clipDist) return;

            // Check If They Clip
            var off = ce.center.x - se.center.x;
            if (Math.abs(off) >= (ce.halfSize + se.halfSize)) return;
            
            ce.halfSize = Math.abs(off) - se.halfSize;
            if (ce.halfSize <= 0) {
                ce.direction = -1;
                se.direction = -1;
                // TODO: Split In Two
                return;
            }
            if (off > 0)
                ce.center.x = se.center.x + se.halfSize + ce.halfSize;
            else
                ce.center.x = se.center.x - se.halfSize - ce.halfSize;
        }
        
        /**
         * Resolves Collision Between A Dynamic Body And A Set Of Islands
         * @param r Dynamic Body
         * @param iList List Of Islands
         * @param fCallback Callback Function For When Collision Inside Of An Island Wants To Be Resolved
         * (After Aggregation Step)
         * func(rect:PhysRectangle, accum:CollisionAccumulator, opt:PhysCallbackOptions):Boolean
         * @param fCollisionCallback Callback Function For When A Collision Occurs Inside Of An Island
         * (All Physics Objects Are In A Localized Coordinate Frame, Not A Global One)
         * func(rect:PhysRectangle, edgeOfCollision:PhysEdge, penetration:Number):void
         */
        public static function Resolve(r:PhysRectangle, iList:Array, fCallback:Function = null, fCollisionCallback:Function = null):void {
            r.motion.MulD(1.1);
            
            for each (var i:PhysIsland in iList) {
                
                // Move From Global To Island Reference Point
                r.center.SubV(i.globalAnchor);
                r.velocity.SubV(i.velocity);
                r.motion.SubV(i.motion);
                
                // Perform Collision Detection
                ResolveIsland(r, i.clippedEdges, fCallback, fCollisionCallback);
                    
                // Move Back In Global Frame Of Reference
                r.center.AddV(i.globalAnchor);
                r.velocity.AddV(i.velocity);
                r.motion.AddV(i.motion);
            }
        }
        private static function ResolveIsland(r:PhysRectangle, eList:Array, fCallback:Function, fCollisionCallback:Function):void {
            // Accumulate All Collisions
            var a:CollisionAccumulator = new CollisionAccumulator();
            for each (var e:PhysEdge in eList) {
                ResolveCollision(r, e, a, fCollisionCallback);
            }
            
            // Use The Callback And Check If Resolution Should Continue
            var opt:PhysCallbackOptions = new PhysCallbackOptions();
            var doResolve:Boolean = fCallback == null ? true : fCallback.call(null, r, a, opt);
            
            // Resolve The Collision
            if (doResolve) {
                var dx = a.accumPX - a.accumNX;
                var dy = a.accumPY - a.accumNY;
                
                if (dx != 0 && opt.breakXVelocity)
                    r.velocity.x = 0;
                if (dy != 0 && opt.breakXVelocity)
                    r.velocity.y = 0;
                if (opt.resolveXDisplacement)
                    r.center.x += dx;
                if (opt.resolveYDisplacement)
                    r.center.y += dy;
            }
        }
        private static function ResolveCollision(r:PhysRectangle, e:PhysEdge, a:CollisionAccumulator, fCollisionCallback:Function):void {
            var disp:Number;
            switch (e.direction) {
                case Cardinal.NX: 
                    if (r.motion.x < 0 || (r.PX - e.center.x) > r.motion.x)
                        return;
                    if (AreEdgesOverlapping(r.center.y, r.halfSize.y, e.center.y, e.halfSize)) {
                        if (r.PX > e.center.x) {
                            disp = r.PX - e.center.x;
                            a.accumNX = Math.max(a.accumNX, disp);
                        } else return;
                    } else return;
                    break;
                case Cardinal.PX:
                    if (r.motion.x > 0 || (e.center.x - r.NX) > -r.motion.x)
                        return;
                    if (AreEdgesOverlapping(r.center.y, r.halfSize.y, e.center.y, e.halfSize)) {
                        if (r.NX < e.center.x) {
                            disp = e.center.x - r.NX;
                            a.accumPX = Math.max(a.accumPX, disp);
                        } else return;
                    } else return;
                    break;
                case Cardinal.NY:
                    if (r.motion.y < 0 || (r.PY - e.center.y) > r.motion.y)
                        return;
                    if (AreEdgesOverlapping(r.center.x, r.halfSize.x, e.center.x, e.halfSize)) {
                        if (r.PY > e.center.y) {
                            disp = r.PY - e.center.y;
                            a.accumNY = Math.max(a.accumNY, disp);
                        } else return;
                    } else return;
                    break;
                case Cardinal.PY:
                    if (r.motion.y > 0 || (e.center.y - r.NY) > -r.motion.y)
                        return;
                    if (AreEdgesOverlapping(r.center.x, r.halfSize.x, e.center.x, e.halfSize)) {
                        if (r.NY < e.center.y) {
                            disp = e.center.y - r.NY;
                            a.accumPY = Math.max(a.accumPY, disp);
                        } else return;
                    } else return;
                    break;
            }
            if (fCollisionCallback != null) fCollisionCallback.call(null, r, e, disp);
        }
        private static function AreEdgesOverlapping(c1:Number, hs1:Number, c2:Number, hs2:Number):Boolean {
            var d:Number = c2 > c1 ? c2 - c1 : c1 - c2;
            return d < (hs1 + hs2);
        }
    }
}