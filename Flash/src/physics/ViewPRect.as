package physics {
    import flash.display.Sprite;
    import pyrokid.Constants;
	import pyrokid.Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ViewPRect {
        public var sprite:Sprite;
        public var phys:PhysRectangle;
        //public var callback:Function = null;
        
        public function ViewPRect(s:Sprite, p:PhysRectangle) {
            sprite = s;
            phys = p;
        }
        
        /**
         * Resolve Physics And Update Sprite
         * @param islands Array Of PhysIslands
         * @param dt Frame Delta-Time
         */
        public function onUpdate(islands:Array, dt:Number, callback:Function):void {
            phys.center.Set(sprite.x, sprite.y).DivD(Constants.CELL);
           
            phys.Update(dt);
            CollisionResolver.Resolve(phys, islands, callback);
            
            sprite.x = phys.center.x * Constants.CELL;
			sprite.y = phys.center.y * Constants.CELL;
        }
    }

}