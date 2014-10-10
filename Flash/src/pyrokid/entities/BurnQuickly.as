package pyrokid.entities {
    import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
    import flash.display.MovieClip;
	import physics.Vector2i;
    import pyrokid.*;
	
	public class BurnQuickly extends TileEntity {
		
		public function BurnQuickly(x:int, y:int):void {
			super(x, y);
		}
		
		protected override function getSpriteForCell(cell:Vector2i):DisplayObject {
            var mc:MovieClip = new Embedded.WoodSWF();
            mc.gotoAndStop(1);
			return mc;
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (currentFrame - ignitionTime == Constants.QUICK_BURN_TIME) {
                for (var i:int = 0; i < cells.length; i++) {
                    
                    var w = new Embedded.WoodExplodeSWF();
                    w.x = cells[i].x*Constants.CELL;
                    w.y = cells[i].y*Constants.CELL;
                    trace(w.x);
                    level.briefClips.push(w);
                    level.addChild(w);
                    
                    level.destroyTilePosition(cells[i].x, cells[i].y);
                    level.tileEntityGrid[cells[i].y][cells[i].x] = null;
                    
                    
                }
            }
        }
		
		public override function ignite(level:Level, ignitionFrame:int):void {
            for (var i:int = 0; i < cellSprites.length; i++) {
                var mc:MovieClip = cellSprites[i] as MovieClip;
                mc.gotoAndStop(2);
            }
            
			_ignitionTime = ignitionFrame;
			level.onFire.push(this);
            
		}
		
	}
	
}