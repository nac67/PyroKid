package physics {
    import flash.display.Sprite;
    import pyrokid.Constants;
    import pyrokid.entities.FreeEntity;
	import pyrokid.Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ViewPRect {
        public var sprite:Sprite;
        public var phys:PhysRectangle;
        public var isFreeEntity:Boolean;
        //public var callback:Function = null;
        
        public function ViewPRect(s:Sprite, p:PhysRectangle) {
            sprite = s;
            phys = p;
            isFreeEntity = sprite is FreeEntity;
        }
        
        /**
         * Resolve Physics And Update Sprite
         * @param islands Array Of PhysIslands
         * @param dt Frame Delta-Time
         */
        public function onUpdate(islands:Array, dt:Number, callback:Function):void {
            phys.center.Set(sprite.x, sprite.y).DivD(Constants.CELL).AddV(phys.halfSize);
           
            if (isFreeEntity) {
                var freeEntity:FreeEntity = sprite as FreeEntity;
                freeEntity.isGrounded = false;
                freeEntity.touchLeft = false;
                freeEntity.touchRight = false;
                freeEntity.touchTop = false;
            }
            
            phys.Update(dt);
            CollisionResolver.Resolve(phys, islands, callback);
            
            sprite.x = (phys.center.x - phys.halfSize.x) * Constants.CELL;
			sprite.y = (phys.center.y - phys.halfSize.y) * Constants.CELL;
        }
    }

}