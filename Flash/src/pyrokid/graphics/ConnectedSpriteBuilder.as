package pyrokid.graphics {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.PixelSnapping;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import Vector2i;
    import Utils;
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ConnectedSpriteBuilder {
        
        public static function buildSpriteFromCoors(coors:Array, bitmap:Bitmap):Bitmap {
            var coor:Vector2i;
            var maxCoor:Vector2i = new Vector2i();
            for each (coor in coors) {
                maxCoor.x = Math.max(maxCoor.x, coor.x);
                maxCoor.y = Math.max(maxCoor.y, coor.y);
            }
            maxCoor.AddD(1);
            var texIdGrid:Array = Utils.newArray(maxCoor.x, maxCoor.y);
            for each (coor in coors) {
                texIdGrid[coor.y][coor.x] = 1;
            }
            var texMap:Object = new Object();
            texMap["1"] = bitmap.bitmapData;
            return buildSprite(texIdGrid, texMap, new ConnectedSpriteOptions());
        }
        
        public static function buildSprite(texIDGrid:Array, textureMap:Object, opt:ConnectedSpriteOptions):Bitmap {
            var h:int = texIDGrid.length;
            var w:int = texIDGrid[0].length;
            
            var texIDGridPadded = new Array(h + 2);
            for (var y = 0; y < texIDGridPadded.length; y++) {
                texIDGridPadded[y] = new Array(w + 2);
                for (var x = 0; x < texIDGridPadded[y].length; x++) {
                    if (x == 0 || x == (w + 1) || y == 0 || y == (h + 1))
                        texIDGridPadded[y][x] = 1;
                    else
                        texIDGridPadded[y][x] = texIDGrid[y - 1][x - 1];
                }
            }
            
            var offsets:Array = ConnectedAtlasStitcher.getConnectedTextureIndices(texIDGridPadded);
            
            var bmpData:BitmapData = new BitmapData(w * opt.imageTileSize, h * opt.imageTileSize, true, 0x00000000); // makes it transparent background
            var sprite:Bitmap = new Bitmap(bmpData, PixelSnapping.ALWAYS, true);
            var cropArea:Rectangle = new Rectangle(0, 0, opt.imageTileSize, opt.imageTileSize);
            for (var y = 0; y < h; y++) {
                for (var x = 0; x < w; x++) {
                    //trace(texIDGrid[y][x]);
                    var objCode:int = texIDGrid[y][x];
                    if (objCode != 0 && textureMap.hasOwnProperty(objCode)) {
                        // Find Correct Cropping Position
                        var off:int = offsets[y][x];
                        var ox:int = off % 12;
                        var oy:int = off / 12;
                        //trace(off + ": " + ox + "," + oy);
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