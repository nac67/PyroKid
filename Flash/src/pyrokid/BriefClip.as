package pyrokid {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import Vector2;
    
    public class BriefClip extends MovieClip {
        
        public var velocity:Vector2;
        public var clip:DisplayObject;
        private var timeToEnd:int;
        private var numFrames:int;
        private var affectedByGravity:Boolean
        private var smoosh:Boolean;
        
        /* If timeToEnd is -1, it ends after all frames have played, otherwise it plays for timeToEnd frames. */
        public function BriefClip(position:Vector2, clip:DisplayObject, velocity:Vector2 = null, timeToEnd:int = -1, affectedByGravity:Boolean = false, smoosh:Boolean = false) {
            this.velocity = velocity == null ? new Vector2() : velocity;
            this.clip = clip;
            this.timeToEnd = timeToEnd;
            this.affectedByGravity = affectedByGravity;
            this.smoosh = smoosh;
            
            if (smoosh){
                clip.x = -clip.width / 2;
                clip.y = -clip.height / 2;
                x = position.x + clip.width / 2;
                y = position.y + clip.height / 2;
            } else {
                x = position.x;
                y = position.y;
            }
            numFrames = 0;
            addChild(clip);
        }
        
        /* Updates the brief clip and returns true iff the clip should be removed. */
        public function update():Boolean {
            numFrames += 1;
            
            if (affectedByGravity) {
                velocity.Add(0, Constants.GRAVITY * Constants.DT * Constants.CELL);
            }
            
            var movement:Vector2 = velocity.copy().MulD(Constants.DT);
            x += movement.x;
            y += movement.y;
            if (smoosh && numFrames < 15) {
                scaleY *= 0.95;
                scaleX *= 1.025;
            }
            
            if (smoosh) {
                rotation += (velocity.x < 0 ? -5 : 5) + (velocity.x / 15);
            }    
                
            if (timeToEnd == -1) {
                var mc:MovieClip = clip as MovieClip;
                return mc.currentFrame == mc.totalFrames;
            }
            return numFrames == timeToEnd;    
        }
        
    }
    
}