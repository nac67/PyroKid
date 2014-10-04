package physics {
	/**
     * A Simple Collidable Box Implementation
     * @author Cristian Zaloj
     */
    public class PhysBox implements IPhysTile {
        private static var edges:Array = [
            new PhysEdge(Cardinal.NX, 0, 0.5, 1),
            new PhysEdge(Cardinal.PX, 1, 0.5, 1),
            new PhysEdge(Cardinal.NY, 0.5, 0, 1),
            new PhysEdge(Cardinal.PY, 0.5, 1, 1)
        ];
        
        public var fallingType:Boolean;
        public function PhysBox(isFalling:Boolean = false) {
            fallingType = isFalling;
        }
        
        public function ProvideEdgesSpecial(edges:Array, offset:Vector2):void {
            return;
        }
        public function ProvideEdgesDirection(side:int, e:Array, offset:Vector2):void {
            var i:int = 0;
            switch(side) {
                case Cardinal.NX: i = 0; break;
                case Cardinal.PX: i = 1; break;
                case Cardinal.NY: i = 2; break;
                case Cardinal.PY: i = 3; break;
            }
            
            var edge:PhysEdge = new PhysEdge(edges[i].direction, edges[i].center.x, edges[i].center.y, edges[i].halfSize * 2);
            edge.center.AddV(offset);
            e.push(edge);
        }
        public function get IsGrounded():Boolean {
            return true;
        }
        public function CanBind(side:int, neighbor:IPhysTile):Boolean {
            return !fallingType || !(neighbor is PhysBox && (neighbor as PhysBox).fallingType);
        }
    }
}