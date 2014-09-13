package pyrokid {
    
    public class PhysicsHandler {
        
        public static const margin:Number = .3;
        
        /**
         * Handles player's x and y movement
         * @param player
         * @param level
         */
        public static function handlePlayer(player:Player, level:Array):void {
            //x movement
            var w:int = player.w,
                h:int = player.h,
                midUpperY:int = player.y + Constants.CELL*margin,
                midLowerY:int = player.y + h - Constants.CELL*margin,
                bodyLeftX:int = player.x,
                bodyRightX:int = player.x + w,
                proposedMovement:Number,
                touchingWall:Boolean,
                halfW:int = w / 2;
            
            if (Key.isDown(65)) {
                proposedMovement = -3;
                touchingWall = isColliding(bodyLeftX + proposedMovement, midUpperY, level, player) ||
                    isColliding(bodyLeftX, midLowerY, level, player);
                if (!touchingWall) {
                    player.x += proposedMovement
                }
            }
            
            if (Key.isDown(68)) {
                proposedMovement = 3;
                touchingWall = isColliding(bodyRightX + proposedMovement, midUpperY, level, player) ||
                    isColliding(bodyRightX, midLowerY, level, player);
                if (!touchingWall) {
                    player.x += proposedMovement;
                }
            }
            
            //gravity
            gravitize(player, level, true);
        }
        
        /**
         * Handles a PhysicsObject's gravity
         * @param object the object to move
         * @param level The array holding the wall values
         * @param isPlayer Whether its the player (allow jumping with jump button)
         */
        public static function gravitize(object:PhysicsObject, level:Array, isPlayer:Boolean):void {
            object.y += object.speedY;
            
            var w:int = object.w,
                h:int = object.h,
                baseY:int = object.y + object.h,
                midLeftX:int = object.x + Constants.CELL*margin,
                midRightX:int = object.x + w - Constants.CELL * margin;
                
            var touchingGround:Boolean = isColliding(midLeftX, baseY, level, object) || isColliding(midRightX, baseY, level, object);
            if (!touchingGround) {
                object.speedY += 1;
            } else {
                
                object.speedY = 0;
                object.y = CoordinateHelper.topOfCell(CoordinateHelper.realToCell(baseY));
                if (isPlayer && Key.isDown(87)) {
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
        public static function isColliding(x:int, y:int, level:Array, self:PhysicsObject):Boolean {
            var cellX:int = CoordinateHelper.realToCell(x),
                cellY:int = CoordinateHelper.realToCell(y);
            
            var cellCollision:Boolean = false;
            
            if (cellY >= 0 && cellY < level.length) {
                var row:Array = level[cellY];
                if (cellX >= 0 && cellX <= row.length) {
                    cellCollision = level[cellY][cellX] == 1;
                }
            }
            
            return cellCollision;
        }
    }
}