package pyrokid.graphics.Camera {
    import adobe.utils.CustomActions;
    import pyrokid.Connector;
    import pyrokid.Constants;
    import pyrokid.tools.Camera;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class CameraController {
        public var zoneBinds:Array = [];
        public var zoneStack:Array = [];
        public var camera:Camera = null;
        
        public var time:Number = 0.0;
        
        private var curTarget:CameraTarget;
        
        public function CameraController(c:Camera, origin:Vector2) {
            camera = c;
            
            curTarget = new CameraTarget();
            if (origin != null) curTarget.position.SetV(origin)
            curTarget.scaling = 1.0;
            curTarget.rotation = 0.0;
        }
        
        public function addZone(zone:CameraZone):void {
            var bind = new Object();
            bind.zone = zone;
            bind.isInStack = false;
            zoneBinds.push(bind);
        }
        
        public function update(p:Vector2, dt:Number):void {
            // Update Internal Time
            time += dt;
            
            // We Desire To Look At The Player's Center
            var desiredTarget:CameraTarget = new CameraTarget();
            desiredTarget.position.SetV(p);
            desiredTarget.scaling = 1.0;
            desiredTarget.rotation = 0.0;
            
            // If In A Zone, Look At That Instead
            updateZones(p);
            if (zoneStack.length > 0) {
                desiredTarget = zoneStack[zoneStack.length - 1].zone.camTarget;
            }
            
            // Interpolation For Smooth Transition
            curTarget = CameraTarget.lerp(curTarget, desiredTarget, Constants.CAMERA_LAG);
            
            // Modify The Camera
            camera.xCamera = curTarget.position.x;
            camera.yCamera = curTarget.position.y;
            camera.rotationCamera = curTarget.rotation;
            camera.scaleCamera = curTarget.scaling;
            camera.x = Constants.WIDTH / 2;
            camera.y = Constants.HEIGHT / 2;
        }
        
        private function updateZones(p:Vector2):void {
            // Pop Off Zones Until We Reach An Available Zone
            for (var i:int = zoneStack.length - 1; i >= 0; i--) {
                var zone:CameraZone = zoneStack[i].zone;
                if (!zone.isInZone(p)) {
                    zoneStack[i].isInStack = false;
                    zoneStack.pop();
                } else {
                    break;
                }
            }
            
            // Check For Zones Not Currently In The Stack
            for each (var bind:Object in zoneBinds) {
                if (bind.isInStack) continue;
                
                // Push If Position Is Inside
                bind.isInStack = bind.zone.isInZone(p);
                if (bind.isInStack) {
                    zoneStack.push(bind);
                }
            }
        }
    }
}