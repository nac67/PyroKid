package pyrokid {
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import Cardinal;
    import Vector2i;
    import Vector2;
    import pyrokid.entities.TileEntity;
    import Utils;
    
    public class Connector extends Sprite {
        
        public static function getActualConnectedGrid(connectedGrid:Array, tileEntityGrid:Array):Array {
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
        
        public static function coorAndDirToString(coor:Vector2i, dir:int):String {
            return coor.toString() + ", " + dir;
        }
        
    }
    
}