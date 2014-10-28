package pyrokid.graphics.Camera {
    import flash.media.Camera;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class CameraTarget {
        public var position:Vector2 = new Vector2();
        public var rotation:Number = 0.0;
        public var scaling:Number = 1.0;
        
        public static function lerp(t1:CameraTarget, t2:CameraTarget, r:Number):CameraTarget {
            var t:CameraTarget = new CameraTarget();
            t.position.SetV(t2.position).SubV(t1.position).MulD(r).AddV(t1.position);
            t.rotation = (t2.rotation - t1.rotation) * r + t1.rotation;
            t.scaling = (t2.scaling - t1.scaling) * r + t1.scaling;
            return t;
        }
    }
}