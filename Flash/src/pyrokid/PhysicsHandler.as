package pyrokid {
    
    public class PhysicsHandler {
        
        /**
         * Handles player's x and y movement
         * @param player
         * @param level
         */
        public static function handlePlayer(player:Player, level:Array):void {
            //x movement
            var proposedMovement:Number,
                midY:int,
                bodyLeftX:int,
                bodyRightX:int,
                touchingWall:Boolean,
                w:int = player.w,
                halfW:int = w / 2;
            
            if (Key.isDown(65)) {
                proposedMovement = -3;
                midY = player.y + halfW;
                bodyLeftX = player.x + proposedMovement;
                touchingWall = isColliding(bodyLeftX, midY, level, player);
                if (!touchingWall) {
                    player.x += proposedMovement
                }
            }
            
            if (Key.isDown(68)) {
                proposedMovement = 3;
                midY = player.y + halfW;
                bodyRightX = player.x + w + proposedMovement;
                touchingWall = isColliding(bodyRightX, midY, level, player);
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
            
            var footLeftX:int = object.x + 15;
            var footRightX:int = object.x + 35;
            var footY:int = object.y + object.h;
            var touchingGround:Boolean = isColliding(footLeftX, footY, level, object) || isColliding(footRightX, footY, level, object);
            if (!touchingGround) {
                object.speedY += 1;
            } else {
                object.speedY = 0;
                object.y = CoordinateHelper.topOfCell(CoordinateHelper.realToCell(footY));
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