package physics {
    import flash.display.Sprite;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ViewPRect {
        public var sprite:Sprite;
        public var phys:PhysRectangle;
        public var callback:Function = null;
        
        public function ViewPRect(s:Sprite, p:PhysRectangle) {
            sprite = s;
            phys = p;
        }
        
        /**
         * Resolve Physics And Update Sprite
         * @param islands Array Of PhysIslands
         * @param dt Frame Delta-Time
         */
        public function onUpdate(islands:Array, dt:Number):void {
            phys.center.x = sprite.x;
            phys.center.y = sprite.y;
           
            phys.Update(dt);
            CollisionResolver.Resolve(phys, islands, callback);
            
            sprite.x = phys.center.x;
            sprite.y = phys.center.y;
        }
    }

}