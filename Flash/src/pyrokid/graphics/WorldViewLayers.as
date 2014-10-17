package pyrokid.graphics {
    import adobe.utils.CustomActions;
    import flash.display.BlendMode;
    import flash.display.Sprite;
	/**
     * The Sprite That Contains All The Layers In The World
     * 
     * Order:
     * Background, Scenery, Fire, Particles, Tiles, Entities
     * 
     * @author Cristian Zaloj
     */
    public class WorldViewLayers extends Sprite {
        /**
         * Background Display Objects Added Here
         */
        public final var background:Sprite = new Sprite();
        /**
         * Scenery Layer For Pretty Visuals
         */
        public final var scenery:Sprite = new Sprite;
        /**
         * Fire Effects Destination
         */
        public final var fire:Sprite = new Sprite();
        /**
         * Other Particles (Projectiles, etc.)
         */
        public final var particles:Sprite = new Sprite();
        /**
         * Level Tiles Layer
         */
        public final var tiles:Sprite = new Sprite();
        /**
         * Level Entities Layer
         */
        public final var entities:Sprite = new Sprite();
        
        public function WorldViewLayers() {
            // Fire Has An Additive Effect
            fire.blendMode = BlendMode.ADD;
            
            // Add Layers In Draw Order
            addChild(background);
            addChild(scenery);
            addChild(fire);
            addChild(particles);
            addChild(tiles);
            addChild(entities);
        }
    }

}