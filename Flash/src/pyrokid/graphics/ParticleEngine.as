package pyrokid.graphics {
    import flash.display.Bitmap;
    import flash.display.BlendMode;
	import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import org.flintparticles.common.actions.Age;
    import org.flintparticles.common.actions.ColorChange;
    import org.flintparticles.common.actions.ScaleImage;
    import pyrokid.Connector;
    import pyrokid.Constants;
    import pyrokid.entities.Player;
    
    import org.flintparticles.common.counters.*;
    import org.flintparticles.common.displayObjects.RadialDot;
    import org.flintparticles.common.initializers.*;
    import org.flintparticles.twoD.actions.*;
    import org.flintparticles.twoD.emitters.Emitter2D;
    import org.flintparticles.twoD.initializers.*;
    import org.flintparticles.twoD.renderers.*;
    import org.flintparticles.twoD.zones.*;
	
	/**
     * A Particle Engine That Operates In The Physics Coordinates System
     * @author Cristian Zaloj
     */
    public class ParticleEngine extends Sprite {
        /**
         * Particle Renderer
         */
        var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
        
        /**
         * Create The Particle Engine With A Renderer
         */
        public function ParticleEngine() {
            super();
            addEventListener(Event.ADDED_TO_STAGE, init);
            addChild(renderer);
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, dispose);

            stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
        }
        private function dispose(e:Event = null):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
            addEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
        }
        private function onClick(e:MouseEvent = null):void {
            var pos:Point = globalToLocal(new Point(e.stageX, e.stageY));
            addFire(new RectangleZone(pos.x, pos.y, pos.x + 1, pos.y + 1));
        }
        
        /**
         * Add A Fire Trail Emitter
         * @param pz Trail Origin In Physics Coordinates
         * @return Emitter-Killing Callback Function
         */
        public function addFireTrail(pz:PointZone):Function {
            var emitter:Emitter2D = new Emitter2D();
            emitter.counter = new Steady(16);
            emitter.addInitializer(new ImageClass(RadialDot, [0.3]));
            emitter.addInitializer(new Position(pz));
            emitter.addInitializer(new Velocity(new PointZone(new Point(0, -1.0))));
            emitter.addInitializer(new Lifetime(0.7, 1.0));
            emitter.addInitializer(new ColorInit(0xffff0000, 0xff3c3c3c));
            emitter.addAction(new Move());
            emitter.addAction(new Age());
            emitter.addAction( new ColorChange( 0xFFFFCC00, 0x00CC0000 ) );
            emitter.addAction( new ScaleImage( 1, 4.5 ) );
            
            renderer.addEmitter(emitter);
            emitter.start();
            
            // Return Kill Function
            return function():void {
                emitter.stop();
                renderer.removeEmitter(emitter);
            };
        }
        /**
         * Add A Fire Particle Emitter
         * @param rz Rectangular Fire Zone Origin In Physics Coordinates
         * @return Emitter-Killing Callback Function
         */
        public function addFire(rz:RectangleZone):Function {
            var emitter:Emitter2D = new Emitter2D();
            emitter.counter = new Steady(5);
            emitter.addInitializer(new ImageClass(RadialDot, [0.7]));
            emitter.addInitializer(new Position(rz));
            emitter.addInitializer(new Velocity(new PointZone(new Point(0, -3.8))));
            emitter.addInitializer(new Lifetime(0.4, 0.7));
            emitter.addAction(new Move());
            emitter.addAction(new Age());
            emitter.addAction( new ColorChange( 0xFFFF8000, 0x00000000 ) );
            //emitter.addAction( new ScaleImage( 2.0, 3.5 ) );
            
            renderer.addEmitter(emitter);
            emitter.start();
            
            // Return Kill Function
            return function():void {
                emitter.stop();
                renderer.removeEmitter(emitter);
            };
        }
    }
}