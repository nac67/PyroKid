package pyrokid {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
    import physics.DynamicEntity;
    
    /**
     * Player can be any width <= 50
     * @author Nick Cheng
     */
    public class Player extends DynamicEntity {
        
        private var _direction:int;
        private var _width:Number;
        private var _height:Number;
        
        private var playerSwf:MovieClip;
        
        public var fireballCharge:int = 0;
        
        public var animIsRunning:Boolean = false;
        public var animIsShooting:Boolean = false;

        public function Player(width:Number, height:Number) {
            super(width, height, 0xCCCCFF);
            
            playerSwf = new Embedded.PlayerSWF() as MovieClip;
            playerSwf.stop();
            addChild(playerSwf);
            
            this._width = width;
            this._height = height;
            
            this.direction = Constants.DIR_RIGHT;
            
            
        }
        
        public function set direction(dir:int) {
            _direction = dir;
            if (dir == Constants.DIR_RIGHT) {
                playerSwf.scaleX = 1;                
                playerSwf.x = 0;
            }
            if (dir == Constants.DIR_LEFT) {
                playerSwf.scaleX = -1;
                playerSwf.x = 30;
            }
        }
        
        public function get direction() {
            return _direction;
        }
        
        public function updateAnimation(isPlayerGrounded:Boolean) {
            if (animIsShooting) {
                playerSwf.gotoAndStop(5);
                if (playerSwf.playershoot.currentFrame == playerSwf.playershoot.totalFrames) {
                    animIsShooting = false;
                }
            } else {
                if(!isPlayerGrounded){
                    if (velocity.y > 0) {
                        playerSwf.gotoAndStop(4);
                        return;
                    } else {
                        playerSwf.gotoAndStop(3);
                        return;
                    }
                }
                
                if (animIsRunning) {
                    playerSwf.gotoAndStop(2);
                } else {
                    playerSwf.gotoAndStop(1);
                }
            }
        }
    
    }

}
