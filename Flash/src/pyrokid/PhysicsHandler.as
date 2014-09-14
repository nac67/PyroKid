package pyrokid {
    
    public class PhysicsHandler {
        
        /**
         * The physics system checks for box to box collisions by considering the two corners nearest
         * the collisions. For example, when checking if the box is touching the ground, it needs to see
         * if the bottom-left corner or the bottom-right corner are touching the ground. If either are,
         * it will stop the box from moving downard. This causes a slight issue however. Say the character 
         * were pressed up against a wall to his right while falling. In this case the bottom right corner would be
         * registering a collision, and it would stop him from falling. To fix this error, I have included the
         * MARGIN variable which brings the corners slightly inside to avoid false collision. For example, when
         * checking for ground collisions, the bottom right corner, will be at the same y-coordinate, but
         * its x-coordinate will be moved slightly left. You can visualize these collision detectors as so:
         *         
         *              U.............U
         *             L...............R
         *             .................
         *             .................
         *             .................
         *             .................
         *             .................
         *             L...............R
         *              B.............B
         *   
         * So what this means is that the ground detection will be checked by the two B locations, while the right
         * wall detection will be checked by the two R locations. This effectively stops the box from getting
         * stuck in unfortunate situations, but it also creates a tradeoff. If margin is too small, there is a
         * high probability that it will register a false collision and stop the block. If the margin is too large
         * The physics will look unrealistic and clip too far around corners. The MARGIN variable controls how far
         * to bring in the corners. The total distance to bring in the corners:
         *
         *      distance-in-pixels = MARGIN*width-of-one-cell
         * 
         * Also note: two dynamic objects on top of each other is unpredictable (just make a taller dynamic
         * object to overcome this), but a player on top of dynamic objects is fine.
         */
        
        public static var MARGIN:Number = .1;
        
        /**
         * Handles player's x and y movement
         * @param player
         * @param level
         */
        public static function handlePlayer(player:Player, level:Array, dynamics:Array):void {
            //x movement
            var w:int = player.w,
                h:int = player.h,
                midUpperY:int = player.y + Constants.CELL*MARGIN,
                midLowerY:int = player.y + h - Constants.CELL*MARGIN,
                bodyLeftX:int = player.x,
                bodyRightX:int = player.x + w,
                proposedMovement:Number,
                touchingWall:Boolean,
                halfW:int = w / 2;
            
            // Check to see if moving sideways would cause collision, if it does NOT, then move player
            if (Key.isDown(Constants.LEFT_BTN)) {
                proposedMovement = -3;
                touchingWall = isColliding(bodyLeftX + proposedMovement, midUpperY, level, dynamics, player) ||
                    isColliding(bodyLeftX, midLowerY, level, dynamics, player);
                if (!touchingWall) {
                    player.x += proposedMovement
                }
            }
            
            if (Key.isDown(Constants.RIGHT_BTN)) {
                proposedMovement = 3;
                touchingWall = isColliding(bodyRightX + proposedMovement, midUpperY, level, dynamics, player) ||
                    isColliding(bodyRightX, midLowerY, level, dynamics, player);
                if (!touchingWall) {
                    player.x += proposedMovement;
                }
            }
            
            //gravity
            gravitize(player, level, dynamics);
        }
        
        /**
         * Handles a PhysicsObject's gravity
         * @param object the object to move
         * @param level The array holding the wall values
         * @param isPlayer Whether its the player (allow jumping with jump button)
         *                 Also to make player hit his head on ceilings
         */
        public static function gravitize(object:PhysicsObject, level:Array, dynamics:Array):void {
            var w:int = object.w,
                h:int = object.h,
                baseY:int = object.y + object.h,
                midX:int = object.x + (w/2),
                midLeftX:int = object.x + Constants.CELL*MARGIN,
                midRightX:int = object.x + w - Constants.CELL * MARGIN,
                touchingGround:Boolean,
                isPlayer:Boolean = object.isPlayer;
                
            // Prevent player from launching through a ceiling
            // If moving player up would cause overlap, prevent it from happening in advance and send player
            // moving downward.
            if (isPlayer) {
                var hittingHead:Boolean = isColliding(midLeftX, object.y + object.speedY, level, dynamics, object) ||
                        isColliding(midRightX, object.y + object.speedY, level, dynamics, object)
                if (hittingHead) {
                    object.speedY = 3;
                }
            }
            
            // Apply speed in direction, then update new baseY
            object.y += object.speedY;
            baseY = object.y + object.h
                
            // If the object is the player, use two points of contact for precision
            // If it is a crate, the object will always be centered in a cell, so only use one point of contact
            if (isPlayer) {
                touchingGround = isColliding(midLeftX, baseY, level, dynamics, object) || isColliding(midRightX, baseY, level, dynamics, object);
            } else {
                
                touchingGround = false;
                var cellsWide:int = CoordinateHelper.realToCell(object.w);
                var halfCell:int = Constants.CELL / 2;
                
                // Check collision for center bottom of each cell that the crate takes up
                for (var i:int = 0; i < cellsWide; i++) {
                    var xpos:int = object.x + halfCell + (Constants.CELL * i);
                    touchingGround = touchingGround || isColliding(xpos, baseY, level, dynamics, object);
                }
            }
            
            // Check if object is touching ground, if so, stop it from moving, orient y position with platform,
            // then allow him to jump if its a player
            if (!touchingGround) {
                object.speedY += 1;
            } else {
                object.speedY = 0;
                
                
                if(isPlayer){
                    object.y = CoordinateHelper.topOfCell(CoordinateHelper.realToCell(baseY));
                }else {
                    var extraY:int = (object.h - Constants.CELL); //account for blocks with height>1
                    object.y = CoordinateHelper.topOfCell(CoordinateHelper.realToCell(baseY))-extraY;
                }
                
                if (isPlayer && Key.isDown(Constants.JUMP_BTN)) {
                    object.speedY = -12;
                }
            }
        }
        
        /**
         * Checks if a given x,y coordinate in pixel-space is colliding with any game objects
         * @param x 
         * @param y
         * @param level The level array
         * @param self The object checking for collision, this is to avoid a self collision
         * @return Whether or not the object is colliding
         */
        public static function isColliding(x:int, y:int, level:Array, dynamics:Array, self:PhysicsObject):Boolean {
            var cellX:int = CoordinateHelper.realToCell(x),
                cellY:int = CoordinateHelper.realToCell(y);
            
            // Check if collide with walls O(1)
            if (cellY >= 0 && cellY < level.length) {
                var row:Array = level[cellY];
                if (cellX >= 0 && cellX <= row.length) {
                    if (level[cellY][cellX] == 1) {
                        return true;
                    }
                }
            }
            
            // Check if collide with dynamic objects O(n)
            // TODO: make islands to manage this ~O(1)
            for (var i:int = 0; i < dynamics.length; i++) {
                if (dynamics[i] != self) {
                    var dx:int = dynamics[i].getCellPosition().x;
                    var dy:int = dynamics[i].getCellPosition().y;
                    var dw:int = dynamics[i].w / Constants.CELL;
                    var dh:int = dynamics[i].h / Constants.CELL;
                    
                    if (cellX >= dx && cellX < dx + dw) {
                        if (cellY >= dy && cellY < dy + dh) {
                            return true;
                        }
                    }
                }
            }
            
            return false;
        }
    }
}