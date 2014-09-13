package pyrokid {
    
    public class PhysicsHandler {
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
                    player.x += proposedMovement
                }
            }
            
            gravitize(player, level, true);
        }
        
        public static function gravitize(object:PhysicsObject, level:Array, isPlayer:Boolean) {
            object.y += object.speedY;
            
            var footLeftX:int = CoordinateHelper.realToCell(object.x + 15);
            var footRightX:int = CoordinateHelper.realToCell(object.x + 35);
            var footY:int = CoordinateHelper.realToCell(object.y + object.h);
            
            var touchingGround:Boolean = level[footY][footLeftX] == 1 || Level.level1[footY][footRightX] == 1;
            if (!touchingGround) {
                object.speedY += 1;
            } else {
                object.speedY = 0;
                object.y = footY * 50 - 50;
                if (isPlayer && Key.isDown(87)) {
                    object.speedY = -12;
                }
            }
        }
        
        public static function isColliding(x:int, y:int, level:Array, self:PhysicsObject) {
            var cellX:int = CoordinateHelper.realToCell(x),
                cellY:int = CoordinateHelper.realToCell(y);
                
            return level[cellY][cellX] == 1;
        }
    }
}