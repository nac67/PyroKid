package pyrokid.graphics.Camera {
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class CameraZone {
        /**
         * Zone's Center Location (For Intersection Testing)
         */
        public var center:Vector2 = new Vector2();
        /**
         * Zone's Half Size (For Intersection Testing)
         */
        public var halfSize:Vector2 = new Vector2();

        /**
         * Towards Where Does This Zone Look
         */
        public var camTarget:CameraTarget = new CameraTarget();
        
        public function isInZone(p:Vector2):Boolean {
            return (Math.abs(p.x - center.x) <= halfSize.x) && (Math.abs(p.y - center.y) <= halfSize.y);
        }
    }
}