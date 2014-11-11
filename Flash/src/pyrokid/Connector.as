package pyrokid {
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import Cardinal;
    import Vector2i;
    import Vector2;
    import pyrokid.entities.TileEntity;
    import Utils;
    
    public class Connector extends Sprite {
        
        public var coorInIsland:Vector2i;
        public var direction:int;
        
        public function Connector(/*coor:Vector2i, */dir:int) {
            //coorInIsland = coor;
            direction = dir;
            var sprite:Sprite = new Embedded.ConnectorSWF() as Sprite;
            sprite.scaleX = sprite.scaleY = 0.7;
            sprite.rotation = dir == Cardinal.NY || dir == Cardinal.PY ? 90 : 0;
            addChild(sprite);
        }
        
        public function setSpriteLocationFromIslandAnchor(islandAnchor:Vector2):void {
            var halfWay:Vector2 = Cardinal.getVector2i(direction).copyAsVec2().DivD(2);
            var spriteCoor:Vector2 = coorInIsland.copyAsVec2().AddV(halfWay).AddD(0.5); // shift from corner to center
            spriteCoor.AddV(islandAnchor).MulD(Constants.CELL);
            x = spriteCoor.x;
            y = spriteCoor.y;
        }
        
        public static function getDictKey(coor:Vector2i, dir:int):String {
            if (dir == Cardinal.NX || dir == Cardinal.NY) {
                coor = Cardinal.getVector2i(dir).AddV(coor);
                dir = Cardinal.getOpposite(dir);
            }
            return coor.toString() + ", " + dir.toString();
        }
        
        public static function getConnectorSprites(connectedGrid:Array, tileEntityGrid:Array):Array {
            var allConnectors:Array = Utils.newArrayOfSize(tileEntityGrid);
            Utils.foreach(tileEntityGrid, function(x:int, y:int, tileEntity:TileEntity):void {
                if (tileEntity == null) {
                    return;
                }
                
                var globalCoor:Vector2i = new Vector2i(x, y);
                var connectorBools:Array = Utils.getBooleansFromInt(connectedGrid[globalCoor.y][globalCoor.x]);
                var actualConnectors:Array = [false, false, false, false];
                for (var i:int = 0; i < 4; i++) {
                    var otherCoor:Vector2i = Cardinal.getVector2i(i).AddV(globalCoor);
                    var otherEntity:TileEntity = Utils.index(tileEntityGrid, otherCoor.x, otherCoor.y);
                    if (connectorBools[i] && otherEntity != null && tileEntity != otherEntity) {
                        actualConnectors[i] = true;
                    }
                }
                allConnectors[y][x] = Utils.getIntFromBooleans(actualConnectors);
            });
            return allConnectors;
        }
        
    }
    
}