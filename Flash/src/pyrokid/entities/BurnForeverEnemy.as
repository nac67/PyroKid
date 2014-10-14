package pyrokid.entities {
    import flash.display.Sprite;
    import pyrokid.*;
    
    public class BurnForeverEnemy extends BackAndForthEnemy {
        
        public function BurnForeverEnemy(level:Level, width:Number, height:Number) {
            var swf:Sprite = new Sprite();
            swf.scaleY = .8
            swf.x = 47;
            swf.y = -10;
            swf.graphics.lineStyle(0x000000);
            swf.graphics.beginFill(0x00FF00);
            swf.graphics.drawRect(0, 0, 100, 100);
            swf.graphics.endFill();
            super(level, width, height, swf);
        }
        
		public override function ignite(level:Level, ignitionFrame:int):void {
            if (!isOnFire()) {
                super.ignite(level, ignitionFrame);
                var die = new Embedded.SpiderDieSWF();
            }
		}
    }
    
}