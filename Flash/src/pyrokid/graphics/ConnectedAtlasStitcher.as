package pyrokid.graphics {
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class ConnectedAtlasStitcher {
        private static var ico:int;
        private static var connectedTextureOffsets:Array = new Array(256);
        
        { // AS3 Static Constructor Bullshit
            
            // Build The Offset Location Into The Connected Texture Bitmap
            for (ico = 0; ico < 256; ico++) {
                connectedTextureOffsets[ico] = 0;
            }
            connectedTextureOffsets[0xFF] = 0;
            connectedTextureOffsets[0xEF] = 1;
            connectedTextureOffsets[0xEE] = 2;
            connectedTextureOffsets[0xFE] = 3;
            connectedTextureOffsets[0xEB] = 4;
            connectedTextureOffsets[0xFA] = 5;
            connectedTextureOffsets[0xAB] = 6;
            connectedTextureOffsets[0xEA] = 7;
            connectedTextureOffsets[0x8A] = 8;
            connectedTextureOffsets[0xA2] = 9;
            connectedTextureOffsets[0x28] = 10;
            connectedTextureOffsets[0x0A] = 11;
            connectedTextureOffsets[0xFB] = 12;
            connectedTextureOffsets[0xE3] = 13;
            connectedTextureOffsets[0xE0] = 14;
            connectedTextureOffsets[0xF8] = 15;
            connectedTextureOffsets[0xAF] = 16;
            connectedTextureOffsets[0xBE] = 17;
            connectedTextureOffsets[0xAE] = 18;
            connectedTextureOffsets[0xBA] = 19;
            connectedTextureOffsets[0x2A] = 20;
            connectedTextureOffsets[0xA8] = 21;
            connectedTextureOffsets[0xA0] = 22;
            connectedTextureOffsets[0x82] = 23;
            connectedTextureOffsets[0xBB] = 24;
            connectedTextureOffsets[0x83] = 25;
            connectedTextureOffsets[0x00] = 26;
            connectedTextureOffsets[0x38] = 27;
            connectedTextureOffsets[0xA3] = 28;
            connectedTextureOffsets[0xE8] = 29;
            connectedTextureOffsets[0x8B] = 30;
            connectedTextureOffsets[0xE2] = 31;
            connectedTextureOffsets[0x08] = 32;
            connectedTextureOffsets[0x02] = 33;
            connectedTextureOffsets[0x88] = 34;
            connectedTextureOffsets[0x22] = 35;
            connectedTextureOffsets[0xBF] = 36;
            connectedTextureOffsets[0x8F] = 37;
            connectedTextureOffsets[0x0E] = 38;
            connectedTextureOffsets[0x3E] = 39;
            connectedTextureOffsets[0x8E] = 40;
            connectedTextureOffsets[0x3A] = 41;
            connectedTextureOffsets[0x2E] = 42;
            connectedTextureOffsets[0xB8] = 43;
            connectedTextureOffsets[0x20] = 44;
            connectedTextureOffsets[0x80] = 45;
            connectedTextureOffsets[0xAA] = 46;
        }
    
        /**
         * Given An Input Of Texture IDs With Padding, Returns An Unpadded Array With Offset Values
         * @param texIDGrid The Island's Textures IDs Padded With 0's On The Outside (Top Left = (0,0))
         */
        public static function getConnectedTextureIndices(texIDGrid:Array):Array {
            var h:int = texIDGrid.length - 2;
            var w:int = texIDGrid[0].length - 2;
            
            var texOffsetGrid = new Array(h);
            
            for (var y:int = 1; y <= h; y++) {
                texOffsetGrid[y - 1] = new Array(w);
                for (var x:int = 1; x <= w; x++) {
                    texOffsetGrid[y - 1][x - 1] = getConnectedTextureOffset(texIDGrid, x, y);
                }
            }
            
            return texOffsetGrid;
        }
        private static function getConnectedTextureOffset(texIDGrid:Array, x:int, y:int):int {
            var connectedOffset:int = 0x00;
            var tex:int = texIDGrid[y][x];
           
            // Top Left
            if (texIDGrid[y - 1][x - 1] != tex) connectedOffset |= 0x80;

            // Top
            if (texIDGrid[y - 1][x] != tex) connectedOffset |= 0xE0;

            // Top Right
            if (texIDGrid[y - 1][x + 1] != tex) connectedOffset |= 0x20;

            // Right
            if (texIDGrid[y][x + 1] != tex) connectedOffset |= 0x38;

            // Bottom Right
            if (texIDGrid[y + 1][x + 1] != tex) connectedOffset |= 0x08;

            // Bottom
            if (texIDGrid[y + 1][x] != tex) connectedOffset |= 0x0E;

            // Bottom Left
            if (texIDGrid[y + 1][x - 1] != tex) connectedOffset |= 0x02;

            // Left
            if (texIDGrid[y][x - 1] != tex) connectedOffset |= 0x83;
            
            return connectedTextureOffsets[connectedOffset];
        }
    }

}