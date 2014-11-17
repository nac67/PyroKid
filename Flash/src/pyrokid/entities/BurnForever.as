package pyrokid.entities {
    import flash.display.MovieClip;
	import flash.display.Sprite;
	import Vector2i;
	import flash.display.DisplayObject;
	import pyrokid.Constants;
	import pyrokid.Level;
    import pyrokid.Embedded;
    import pyrokid.BriefClip;
	
	public class BurnForever extends TileEntity {
		
		public function BurnForever(x:int, y:int, objCode:int) {
			super(x, y, objCode);
		}
		
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            var mc:MovieClip = new Embedded.OilSWF();
            mc.gotoAndStop(1);
			return mc;
		}
        
        public override function ignite(level:Level, coor:Vector2i = null, dir:int = -1):Boolean {
            var lit:Boolean = super.ignite(level, coor, dir);
            if (lit) {
                for each (var cellSprite:DisplayObject in fireSprites) {
                    addChild(cellSprite);
                }
            }
            return lit;
		}
        
        public function douse(level:Level):void {
            // TODO -- Aaron probably make this more generic to work on any flaming object
            if (!isOnFire()) {
                return;
            }
            _ignitionTime = -1;
            var self = this;
            level.onFire.filter(function(item:TileEntity, i:int, a:Array):Boolean {
                return item != self;
            });
            for each (var cellSprite:DisplayObject in fireSprites) {
                removeChild(cellSprite);
            }
            
            for each (var cell:Vector2i in cells) {
                var steam:MovieClip = new Embedded.DouseSWF() as MovieClip;
                var pos:Vector2 = new Vector2(cell.x, cell.y);
                pos.AddV(getGlobalAnchor());
                pos.MulD(Constants.CELL);
                var bc:BriefClip = new BriefClip(pos, steam)
                level.briefClips.push(bc);
                level.addChild(bc);
            }
        }
	}
	
}