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
			var child:Sprite = new Sprite();
            var bmp:Bitmap = new Embedded.WoodBMP() as Bitmap;
			child.addChild(bmp);
			return child;
		}
        
        public override function updateFire(level:Level, currentFrame:int):void {
            if (currentFrame - ignitionTime == Constants.QUICK_BURN_TIME) {
                for (var i:int = 0; i < cells.length; i++) {
                    level.destroyTilePosition(cells[i].x, cells[i].y);
                    level.tileEntityGrid[cells[i].y][cells[i].x] = null;
                }
            }
        }
		
		public override function ignite(level:Level, ignitionFrame:int):void {
            //for (var i:int = 0; i < cellSprites.length; i++) {
                //var mc:MovieClip = cellSprites[i] as MovieClip;
                //mc.gotoAndStop(2);
            //}
            
			_ignitionTime = ignitionFrame;
			level.onFire.push(this);
            
		}
		
	}
	
}