package physics {
	import flash.display.Sprite;
    import pyrokid.Constants;
    import pyrokid.entities.TileEntity;
	import Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ViewPIsland {
        public var sprite:TileEntity;
        public var phys:PhysIsland;
        
        public function ViewPIsland(s:TileEntity, p:PhysIsland) {
            sprite = s;
            phys = p;
        }
        
        /**
         * All Islands Need To Simulated At Once
         * @param islands Array Of PhysIslands
         * @param grav Gravity Acceleration
         * @param dt Frame Delta-Time
         */
        public static function updatePhysics(islands:Array, columns:Array, grav:Vector2):void {
            IslandSimulator.Simulate(islands, columns, grav, Constants.DT);
        }
        
        /**
         * Update Sprite Position To Match Physics
         */
        public function onUpdate():void {
            sprite.x = phys.globalAnchor.x * Constants.CELL;
			sprite.y = phys.globalAnchor.y * Constants.CELL;
            sprite.globalAnchor = phys.globalAnchor;
            sprite.velocity.x = phys.velocity.x * Constants.CELL;
            sprite.velocity.y = phys.velocity.y * Constants.CELL;
        }
    }
}