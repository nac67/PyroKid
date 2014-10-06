package physics {
	import flash.display.Sprite;
	import pyrokid.Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ViewPIsland {
        public var sprite:Sprite;
        public var phys:PhysIsland;
        
        public function ViewPIsland(s:Sprite, p:PhysIsland) {
            sprite = s;
            phys = p;
        }
        
        /**
         * All Islands Need To Simulated At Once
         * @param islands Array Of PhysIslands
         * @param grav Gravity Acceleration
         * @param dt Frame Delta-Time
         */
        public static function updatePhysics(islands:Array, grav:Vector2, dt:Number) {
            IslandSimulator.Simulate(islands, grav, dt);
        }
        
        /**
         * Update Sprite Position To Match Physics
         */
        public function onUpdate():void {
			var spritePos:Vector2i = Utils.getSpritePosition(phys.globalAnchor);
            sprite.x = spritePos.x;
			sprite.y = spritePos.y;
        }
    }
}