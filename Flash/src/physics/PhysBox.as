package physics {
	import flash.display.Sprite;
	import pyrokid.Constants;
	import physics.GameEntity;
	/**
     * A Simple Collidable Box Implementation
     * @author Cris tian Zaloj
     */
    public class PhysBox extends GameEntity implements IPhysTile {
        private static var edges:Array = [
            new PhysEdge(Cardinal.NX, 0, 0.5, 1),
            new PhysEdge(Cardinal.PX, 1, 0.5, 1),
            new PhysEdge(Cardinal.NY, 0.5, 0, 1),
            new PhysEdge(Cardinal.PY, 0.5, 1, 1)
        ];
		
		private var grounded:Boolean;
		
		public function PhysBox(grounded:Boolean = true, color:uint = 0xFFEECC) {
            super(1, 1, color);
			this.grounded = grounded;
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
            return grounded;
        }
        public function CanBind(side:int):Boolean {
            return true;
        }
    }
}