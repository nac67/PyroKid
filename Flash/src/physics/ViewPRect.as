package physics {
    import flash.display.Sprite;
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
			phys.center = Utils.getCellXYCenter(new Vector2i(sprite.x, sprite.y));
           
            phys.Update(dt);
            CollisionResolver.Resolve(phys, islands, callback);
            
			var spritePos:Vector2i = Utils.getSpritePosition(phys.center);
            sprite.x = spritePos.x;
			sprite.y = spritePos.y;
        }
    }

}