package pyrokid {
    import flash.display.Sprite;
    import physics.Vector2;
    
    public class PlayerAttackObject {
        public var isFireball:Boolean;
        public var fireballSprite:Fireball;
        public var age:int;
        public var pos:Vector2;
        
        public function PlayerAttackObject(fireballSprite:Fireball = null, pos:Vector2=null) {
            this.fireballSprite = fireballSprite;
            this.pos = pos;
            isFireball = fireballSprite != null;
            age = 0;
        }
        
        public static function deleteThis(level:Level, attackObj) {
            if (attackObj.isFireball) {
                return !level.fireballs.contains(attackObj.fireballSprite);
            }else {
                attackObj.age++;
                return attackObj.age > 1;
            }
            
        }
        
        public function collidingWith(sprite:Sprite) {
            if (isFireball) {
                return sprite.hitTestObject(fireballSprite);
            }else {
                var xdis = pos.x - (sprite.x + Constants.CELL / 2);
                var ydis = pos.y - (sprite.y + Constants.CELL / 2);
                var distance = Math.sqrt(xdis * xdis + ydis * ydis);
                return distance < 40;
            }
        }
    
    }

}