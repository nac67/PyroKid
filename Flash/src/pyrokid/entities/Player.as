package pyrokid.entities {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.utils.ByteArray;
	import physics.PhysRectangle;
    import Vector2i;
	import pyrokid.*;
    import pyrokid.tools.*;
    
    /**
     * Player can be any width <= 50
     * @author Nick Cheng
     */
    public class Player extends FreeEntity {
        
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
        private var shootDirection:int=0;
        
        public var prevFrameFireBtn:Boolean = false;
        public var prevFrameJumpBtn:Boolean = false;
        
        private var onFireSprite:Sprite;

        public function Player(level:Level) {
            super(level, 1, 28, 44);
            
            //this.glowVisible = true;
            //this.glowRadius = 30;
            //this.glow = 0;
            
            
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
            
            onFireSprite = new Sprite();
            addChild(onFireSprite);
            onFireSprite.x = x;
            onFireSprite.y = y;
            onFireSprite.graphics.lineStyle(0x000000);
            onFireSprite.graphics.beginFill(0xFF0055);
            onFireSprite.graphics.drawRect(0, 0, 20, 20);
            onFireSprite.graphics.endFill();
            onFireSprite.visible = false;
        }
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var lit:Boolean = super.ignite(level, coor, dir);
            if (lit) {
                onFireSprite.visible = true;
                var bc:BriefClip = new BriefClip(new Vector2(x, y), new Embedded.PlayerDieFireSWF() as MovieClip);
                kill(level, bc, Constants.DEATH_BY_FIRE);
            }
            return lit;
        }
        
        public override function kill(level:Level, deathAnimation:BriefClip = null, method:String = ""):void {
            level.gameOverState = Constants.GAME_OVER_FADING;
            if (deathAnimation == null) {
                var delayedFunc:Function = function():void {
                    level.gameOverState = Constants.GAME_OVER_COMPLETE;
                }
                level.delayedFunctions[delayedFunc] = Constants.FADE_TIME;
            }
            var center:Vector2i = getCenter();
            Main.log.logDeath(Utils.realToCell(center.x), Utils.realToCell(center.y), method, level.frameCount);
            Main.log.logEndLevel();
            super.kill(level, deathAnimation);
        }
        
        public function damageFromEnemyContact(level:Level):void {
            var bc:BriefClip = new BriefClip(new Vector2(x, y), new Embedded.PlayerDiePainSWF() as MovieClip);
            kill(level, bc, Constants.DEATH_BY_ENEMY);
        }
        
        public override function update(level:Level):void {
            super.update(level);
            
            // Moving left right
			velocity.x = 0;
            animIsRunning = false; 
            if (Key.isDown(Constants.LEFT_BTN)) {
                velocity.x -= Constants.PLAYER_XSPEED;
                direction = Constants.DIR_LEFT;
                animIsRunning = true;
            }
            if (Key.isDown(Constants.RIGHT_BTN)) {
                velocity.x += Constants.PLAYER_XSPEED;
                direction = Constants.DIR_RIGHT;
                animIsRunning = true;
            }
            
            // Vertical movement
			if (isGrounded && Key.isDown(Constants.JUMP_BTN) && (!prevFrameJumpBtn || Constants.ALLOW_JUMP_HOLD)) {
				velocity.y -= Constants.PLAYER_JUMP_SPEED * (1 + velocity.y * Constants.PLAYER_JUMP_FALLING_MULTIPLIER);
			}
			velocity.Add(0, Constants.GRAVITY_ENT * Constants.CELL * Constants.DT);
			prevFrameJumpBtn = Key.isDown(Constants.JUMP_BTN);
            
            // Firing
            var shootButton = Key.isDown(Constants.AIM_LEFT_BTN) || Key.isDown(Constants.AIM_RIGHT_BTN) ||
                    Key.isDown(Constants.AIM_UP_BTN) || Key.isDown(Constants.AIM_DOWN_BTN);
  
            if (Key.isDown(Constants.AIM_LEFT_BTN)) {
                shootDirection = Constants.DIR_LEFT;
            }
            if (Key.isDown(Constants.AIM_RIGHT_BTN)) {
                shootDirection = Constants.DIR_RIGHT;
            }
            if (Key.isDown(Constants.AIM_UP_BTN)) {
                shootDirection = Constants.DIR_UP;
            }
            if (Key.isDown(Constants.AIM_DOWN_BTN)) {
                shootDirection = Constants.DIR_DOWN;
            }
            if (shootButton && !isCharging) {
                // Fire button pressed and not already charging
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
            // Direction of movie clips
            var faceDirection = direction;
            if ((isCharging || isShooting) && (shootDirection == Constants.DIR_LEFT ||
                    shootDirection == Constants.DIR_RIGHT)) {
                faceDirection = shootDirection;
            }
            
            if (faceDirection == Constants.DIR_RIGHT) {
                legsSWF.scaleX = 1;                
                legsSWF.x = 0;
                torsoSWF.scaleX = 1;                
                torsoSWF.x = 0;
            }
            if (faceDirection == Constants.DIR_LEFT) {
                legsSWF.scaleX = -1;
                legsSWF.x = 30;
                torsoSWF.scaleX = -1;
                torsoSWF.x = 30;
            }
            
            
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
                var onShootingFrame = torsoSWF.currentFrame == 7 || 
                        torsoSWF.currentFrame == 10 || torsoSWF.currentFrame == 13;
                if (onShootingFrame){
                    if(torsoSWF.playershoot.currentFrame == torsoSWF.playershoot.totalFrames) {
                        isShooting = false;
                    }
                }else {
                    if (shootDirection == Constants.DIR_LEFT || shootDirection == Constants.DIR_RIGHT) {
                        torsoSWF.gotoAndStop(7);
                    } else if (shootDirection == Constants.DIR_UP) {
                        torsoSWF.gotoAndStop(10);
                    } else if (shootDirection == Constants.DIR_DOWN) {
                        torsoSWF.gotoAndStop(13);
                    }
                }
                
            } else if (isCharging) {
                if (fireballCharge < Constants.FIREBALL_CHARGE) {
                    
                    if (shootDirection == Constants.DIR_LEFT || shootDirection == Constants.DIR_RIGHT) {
                        torsoSWF.gotoAndStop(5);
                    } else if (shootDirection == Constants.DIR_UP) {
                        torsoSWF.gotoAndStop(8);
                    } else if (shootDirection == Constants.DIR_DOWN) {
                        torsoSWF.gotoAndStop(11);
                    }
                
                }else {
                    if (shootDirection == Constants.DIR_LEFT || shootDirection == Constants.DIR_RIGHT) {
                        torsoSWF.gotoAndStop(6);
                    } else if (shootDirection == Constants.DIR_UP) {
                        torsoSWF.gotoAndStop(9);
                    } else if (shootDirection == Constants.DIR_DOWN) {
                        torsoSWF.gotoAndStop(12);
                    }
                }
                
            } else {
                if (!isGrounded) {
                    if (velocity.y < 0) {
                        torsoSWF.gotoAndStop(3);
                    } else {
                        torsoSWF.gotoAndStop(4);
                    }
                } else {
                    if(velocity.x == 0) {
                        torsoSWF.gotoAndStop(1);
                    } else {
                        torsoSWF.gotoAndStop(2);
                    }
                }
            }
            
            // Aimer
            aimSWF.alpha = .0 + 1.0 * (fireballCharge / Constants.FIREBALL_CHARGE);
            var scale:Number = (fireballCharge == Constants.FIREBALL_CHARGE ? .9 : .7);
            aimSWF.scaleX = aimSWF.scaleY = scale;
            
            var dirVec:Vector2i = Utils.getXYMultipliers(shootDirection);
            
            aimSWF.x = getCenterLocal().x + dirVec.x * Fireball.calculateRangeInCells(fireballCharge) * Constants.CELL;
            aimSWF.y = getCenterLocal().y + dirVec.y * Fireball.calculateRangeInCells(fireballCharge) * Constants.CELL;
        }
    
    }

}
