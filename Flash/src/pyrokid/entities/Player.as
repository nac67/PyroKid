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
        public var isAimingUp:Boolean = false;
        
        public var prevFrameFireBtn:Boolean = false;
        public var prevFrameJumpBtn:Boolean = false;
        
        private var shootDirection:int=0;

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
        
        
        public function update(level:Level):void {
            isAimingUp = Key.isDown(Constants.AIM_UP_BTN);
            
            // Moving left right
			velocity.x = 0;
            animIsRunning = false; 
            if (Key.isDown(Constants.LEFT_BTN)) {
                velocity.x -= 2*Constants.CELL;
                direction = Constants.DIR_LEFT;
                animIsRunning = true;
            }
            if (Key.isDown(Constants.RIGHT_BTN)) {
                velocity.x += 2*Constants.CELL;
                direction = Constants.DIR_RIGHT;
                animIsRunning = true;
            }
            
            // Vertical movement
			velocity.Add(0, Constants.GRAVITY * Constants.CELL * Constants.DT);
			if (isGrounded && Key.isDown(Constants.JUMP_BTN) && !prevFrameJumpBtn) {
				velocity.y = -6*Constants.CELL;
			}
			prevFrameJumpBtn = Key.isDown(Constants.JUMP_BTN);
            
            // Firing
            var shootButton = Key.isDown(Key.LEFT) || Key.isDown(Key.RIGHT) || Key.isDown(Key.UP) || Key.isDown(Key.DOWN);
  
            if (Key.isDown(Key.LEFT)) {
                shootDirection = Constants.DIR_LEFT;
            }
            if (Key.isDown(Key.RIGHT)) {
                shootDirection = Constants.DIR_RIGHT;
            }
            if (Key.isDown(Key.UP)) {
                shootDirection = Constants.DIR_UP;
            }
            if (Key.isDown(Key.DOWN)) {
                shootDirection = Constants.DIR_DOWN;
            }
            if (shootButton && !prevFrameFireBtn) {
                // Fire button just pressed
                if(fireballCooldown == 0){
                    fireballCharge = 0;
                    isCharging = true;
                    fireballCooldown = Constants.FIREBALL_COOLDOWN;
                }
			} else if (shootButton) {
				// Fire button is being held
                if (isCharging && fireballCharge < Constants.FIREBALL_CHARGE) {
				    fireballCharge++;
                }
			} else if(prevFrameFireBtn) {
				// Fire button is released
                if(isCharging){
                    isCharging = false;
                    isShooting = true;
                    
                    if (fireballCharge > Constants.FIREBALL_CHARGE) {
                        level.launchFireball(Constants.MAX_BALL_RANGE, shootDirection);
                    } else {
                        var range = Fireball.calculateRangeInCells(fireballCharge);
                        level.launchFireball(range, shootDirection);
                    }
                }
                fireballCharge = 0;
			}
            if (fireballCooldown > 0) fireballCooldown--;
			prevFrameFireBtn = shootButton;
            
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
            aimSWF.alpha = .0 + 1.0 * (fireballCharge / Constants.FIREBALL_CHARGE);
            var scale = (fireballCharge == Constants.FIREBALL_CHARGE ? .9 : .7);
            aimSWF.scaleX = aimSWF.scaleY = scale;
            
            //var shootDirection = (isAimingUp ? Constants.DIR_UP : direction);
            var dirVec = Utils.getXYMultipliers(shootDirection);
            
            aimSWF.x = getCenterLocal().x + dirVec.x * Fireball.calculateRangeInCells(fireballCharge) * Constants.CELL;
            aimSWF.y = getCenterLocal().y + dirVec.y * Fireball.calculateRangeInCells(fireballCharge) * Constants.CELL;
        }
    
    }

}
