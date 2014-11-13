package pyrokid.graphics.Camera {
    import adobe.utils.CustomActions;
    import flash.display.Sprite;
    import flash.geom.Point;
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
        
        public function update(p:Vector2, s:Sprite, minCoords:Point, maxCoords:Point, dt:Number, ds:Number = 1.0):void {
            // Update Internal Time
            time += dt;
            
            // We Desire To Look At The Player's Center
            var desiredTarget:CameraTarget = new CameraTarget();
            desiredTarget.position.SetV(p);
            desiredTarget.scaling = ds;
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
            camera.scaleCamera = curTarget.scaling;
            camera.x = Constants.WIDTH / 2;
            camera.y = Constants.HEIGHT / 2;
            
            // Contain The Camera
            var disp:Point = new Point(0, 0);
            minCoords = s.localToGlobal(minCoords);
            maxCoords = s.localToGlobal(maxCoords);
            if (maxCoords.x < Constants.WIDTH) disp.x = maxCoords.x - Constants.WIDTH;
            if (maxCoords.y < Constants.HEIGHT) disp.y = maxCoords.y - Constants.HEIGHT;
            if (minCoords.x > 0) disp.x = minCoords.x;
            if (minCoords.y > 0) disp.y = minCoords.y;
            if (disp.x != 0 || disp.y != 0) {
                disp.x += Constants.WIDTH / 2;
                disp.y += Constants.HEIGHT / 2;
                disp = camera.globalToLocal(disp);
                camera.xCamera += disp.x;
                camera.yCamera += disp.y;
            }
            
            camera.rotationCamera = curTarget.rotation;
        }

        public function updateNick(p:Vector2, maxCoords:Point) {
            var desiredTarget:CameraTarget = new CameraTarget();
            desiredTarget.position.SetV(p);

            curTarget = CameraTarget.lerp(curTarget, desiredTarget, Constants.CAMERA_LAG);
            camera.xCamera = Math.floor(curTarget.position.x);
            camera.yCamera = Math.floor(curTarget.position.y);

            // contain in bounds
            //camera.xCamera = Math.max(0,camera.xCamera);
            //camera.yCamera = Math.max(0,camera.yCamera);
            //camera.xCamera = Math.min()
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