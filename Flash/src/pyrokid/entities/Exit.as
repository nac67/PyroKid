package pyrokid.entities {
    import pyrokid.Constants;
    import physics.Vector2i;
    import flash.display.DisplayObject;
    import pyrokid.Embedded;
    import pyrokid.Level;
    
    public class Exit extends TileEntity {
        
        private var _canExit:Boolean = false;
        
		public function Exit(x:int, y:int) {
            super(x, y, Constants.EXIT_TILE_CODE);
		}
        
        public function canExit():Boolean {
            return _canExit;
        }
        
        public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                trace("exit ignited");
            }
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (currentFrame - ignitionTime == Constants.SPREAD_RATE) {
                _canExit = true;
                trace("exit here");
            }
        }
        
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            return new Embedded.DirtBMP();
		}
        
    }
    
}