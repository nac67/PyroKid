package physics {
	/**
     * A Simple Collidable Box Implementation
     * @author Cristian Zaloj
     */
    public class PhysBox implements IPhysTile {
        private var edges:Array;
        
        /**
         * Construct A Box Found At: [x,x+s]  [y,y+s]
         * @param s Size Of The Square
         * @param x Minimum X Coordinate
         * @param y Minimum Y Coordinate
         */
        public function PhysBox(s:Number, x:Number, y:Number) {
            var hs:Number = s / 2;
            var center:Vector2 = new Vector2(x, y).AddD(hs);
            
            edges = new Array(4);
            edges[Cardinal.NX] = new PhysEdge(Cardinal.NX, center.x - hs, center.y, s);
            edges[Cardinal.PX] = new PhysEdge(Cardinal.PX, center.x + hs, center.y, s);
            edges[Cardinal.NY] = new PhysEdge(Cardinal.NY, center.x, center.y - hs, s);
            edges[Cardinal.PY] = new PhysEdge(Cardinal.PY, center.x, center.y + hs, s);
        }
        
        public function ProvideEdgesSpecial(edges:Array):void {
            return;
        }
        public function ProvideEdgesDirection(side:int, e:Array):void {
            e.push(edges[side]);
        }
        public function get IsGrounded():Boolean {
            return true;
        }
        public function CanBind(side:int):Boolean {
            return true;
        }
    }

}