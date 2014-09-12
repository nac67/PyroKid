package pyrokid {
    public class PhysicsHandler {
        public static function handlePlayer (player:Player, level:Array):void {
            //x movement
            if(Key.isDown(65)){
                var proposedMovement:Number = -5;
                var midY:int = CoordinateHelper.realToCell(player.y+25);
                var bodyLeftX:int = CoordinateHelper.realToCell(player.x+proposedMovement); 
                var touchingWall:Boolean = level[midY][bodyLeftX] == 1;
                if(!touchingWall){
                    player.x += proposedMovement
                }
            }

            if(Key.isDown(68)) {
                var proposedMovement:Number = 5;
                var midY:int = CoordinateHelper.realToCell(player.y+25);
                var bodyRightX:int = CoordinateHelper.realToCell(player.x+45+proposedMovement); 
                var touchingWall:Boolean = level[midY][bodyRightX] == 1;
                if(!touchingWall){
                    player.x += proposedMovement
                }
            }

            //gravity
            gravitize(player, level);
        }

        public static function gravitize(object, level:Array) {
            object.y += object.speedY;

            var footLeftX:int = CoordinateHelper.realToCell(object.x+15);
            var footRightX:int = CoordinateHelper.realToCell(object.x+35);
            var footY:int = CoordinateHelper.realToCell(object.y+50);

            var touchingGround:Boolean = level[footY][footLeftX] == 1 || Level.level1[footY][footRightX] == 1;
            if(!touchingGround) {
                object.speedY+=1;
            }else{
                object.speedY = 0;
                object.y = footY*50-50;
                if(Key.isDown(87)){
                    object.speedY = -12;
                }
            }
        }
    }
}