package pyrokid.graphics {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.PixelSnapping;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ConnectedSpriteBuilder {
        public static function buildSprite(texIDGrid:Array, textureMap:Object, opt:ConnectedSpriteOptions):Bitmap {
            var h:int = texIDGrid.length;
            var w:int = texIDGrid[0].length;
            
            var texIDGridPadded = new Array(h + 2);
            for (var y = 0; y < texIDGridPadded.length; y++) {
                texIDGridPadded[y] = new Array(w + 2);
                for (var x = 0; x < texIDGridPadded[y].length; x++) {
                    if (x == 0 || x == (w + 1) || y == 0 || y == (h + 1))
                        texIDGridPadded[y][x] = 0;
                    else
                        texIDGridPadded[y][x] = texIDGrid[y - 1][x - 1];
                }
            }
            
            var offsets:Array = ConnectedAtlasStitcher.getConnectedTextureIndices(texIDGridPadded);
            
            var bmpData:BitmapData = new BitmapData(w * opt.imageTileSize, h * opt.imageTileSize);
            var sprite:Bitmap = new Bitmap(bmpData, PixelSnapping.ALWAYS, true);
            var cropArea:Rectangle = new Rectangle(0, 0, opt.imageTileSize, opt.imageTileSize);
            for (var y = 0; y < h; y++) {
                for (var x = 0; x < w; x++) {
                    trace(texIDGrid[y][x]);
                    if (texIDGrid[y][x] != 0) {
                        // Find Correct Cropping Position
                        var off:int = offsets[y][x];
                        var ox:int = off % 12;
                        var oy:int = off / 12;
                        trace(off + ": " + ox + "," + oy);
                        cropArea.x = opt.imageTileSize * x;
                        cropArea.y = opt.imageTileSize * y;

                        // Find The Destination Point
                        var mDest:Matrix = new Matrix();
                        mDest.translate((x-ox) * opt.imageTileSize, (y-oy) * opt.imageTileSize);
                        
                        // Draw Onto Sprite's Data
                        var bitmap:BitmapData = textureMap[texIDGrid[y][x]];
                        bmpData.draw(bitmap, mDest, null, null, cropArea, false);
                    }
                }
            }
            sprite.width = opt.spriteTileSize * w;
            sprite.height = opt.spriteTileSize * h;
            return sprite;
        }
        
    }

}