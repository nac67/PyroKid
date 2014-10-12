package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
	import physics.PhysRectangle;
	import pyrokid.*;
    
    /**
     * Player can be any width <= 50
     * @author Nick Cheng
     */
    public class Player extends FreeEntity {
        
        private var _direction:int;
        private var _width:Number;
        private var _height:Number;
        
        private var legsSWF:MovieClip;
        private var torsoSWF:MovieClip;
        private var aimSWF:Sprite;
        
        public var fireballCooldown:int = 0; //0 = ready to shoot, otherwise decrement
        public var fireballCharge:int = 0;
        
        public var animIsRunning:Boolean = false;
        
        public var isCharging:Boolean = false;
        public var isShooting:Boolean = false;
        
        
        public var prevFrameFireBtn:Boolean = false;
        public var prevFrameJumpBtn:Boolean = false;

        public function Player(width:Number, height:Number) {
            super(width, height);
            
            legsSWF = new Embedded.PlayerLegsSWF() as MovieClip;
            legsSWF.stop();
            legsSWF.y = -5;
            addChild(legsSWF);
            
            torsoSWF = new Embedded.PlayerTorsoSWF() as MovieClip;
            torsoSWF.stop();
            torsoSWF.y = -5;
            addChild(torsoSWF);
            
            aimSWF = new Embedded.CrosshairSWF() as Sprite;
            aimSWF.x = getCenterLocal().x;
            aimSWF.y = getCenterLocal().y;
            aimSWF.scaleX = aimSWF.scaleY = .7;
            addChild(aimSWF);
            
            
            this._width = width;
            this._height = height;
            
            this.direction = Constants.DIR_RIGHT;
            
            
        }
        
        public function set direction(dir:int):void {
            _direction = dir;
            if (dir == Constants.DIR_RIGHT) {
                legsSWF.scaleX = 1;                
                legsSWF.x = 0;
                torsoSWF.scaleX = 1;                
                torsoSWF.x = 0;
            }
            if (dir == Constants.DIR_LEFT) {
                legsSWF.scaleX = -1;
                legsSWF.x = 30;
                torsoSWF.scaleX = -1;
                torsoSWF.x = 30;
            }
        }
        
        public function get direction():int {
            return _direction;
        }
        
        
        public function update(level:Level) {
            
            
			velocity.Add(0, Constants.GRAVITY *Constants.CELL* Constants.DT);
			velocity.x = 0;
			if (Key.isDown(Constants.LEFT_BTN)) {
				velocity.x -= 2*Constants.CELL;
				direction = Constants.DIR_LEFT;
				animIsRunning = true;
			} else if (Key.isDown(Constants.RIGHT_BTN)) {
				velocity.x += 2*Constants.CELL;
				direction = Constants.DIR_RIGHT;
				animIsRunning = true;
			} else {
				animIsRunning = false;                    
			}
			
			if (isGrounded && Key.isDown(Constants.JUMP_BTN) && !prevFrameJumpBtn) {
				velocity.y = -6*Constants.CELL;
			}
			prevFrameJumpBtn = Key.isDown(Constants.JUMP_BTN);
            
            updateAnimation();
        }
        
        
        
        public function updateAnimation():void {
            // Legs
            if (!isGrounded) {
                legsSWF.gotoAndStop(3);
            } else if(animIsRunning) {
                legsSWF.gotoAndStop(2);
            }else {
                legsSWF.gotoAndStop(1);
            }
            
            // Torso
            if (isShooting) {
                if (torsoSWF.playershoot.currentFrame == torsoSWF.playershoot.totalFrames) {
                    isShooting = false;
                }
                torsoSWF.gotoAndStop(4);
                
            } else if (isCharging) {
                if (fireballCharge < Constants.FIREBALL_CHARGE) {
                    torsoSWF.gotoAndStop(5);
                }else {
                    torsoSWF.gotoAndStop(6);
                }
                
            } else {
                if (!isGrounded) {
                    if (velocity.y < 0) {
                        torsoSWF.gotoAndStop(2);
                    } else {
                        torsoSWF.gotoAndStop(3);
                    }
                } else {
                    torsoSWF.gotoAndStop(1);
                }
            }
            
            // Aimer
            aimSWF.alpha = .2 + .8 * (fireballCharge / Constants.FIREBALL_CHARGE);
            var scale = (fireballCharge == Constants.FIREBALL_CHARGE ? .9 : .7);
            aimSWF.scaleX = aimSWF.scaleY = scale;
            
            
            var dirVec = Utils.getXYMultipliers(direction);
            
            aimSWF.x = getCenterLocal().x + dirVec.x * Fireball.calculateRangeInCells(fireballCharge) * Constants.CELL;
            aimSWF.y = getCenterLocal().y + dirVec.y * Fireball.calculateRangeInCells(fireballCharge) * Constants.CELL;
        }
    
    }

}
