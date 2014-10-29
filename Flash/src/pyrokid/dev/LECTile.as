package pyrokid.dev {
    import adobe.utils.CustomActions;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
	import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.WeakFunctionClosure;
    import pyrokid.Embedded;
    import pyrokid.graphics.ConnectedSpriteBuilder;
    import pyrokid.graphics.ConnectedSpriteOptions;
    import pyrokid.Level;
    import pyrokid.LevelRecipe;
    import ui.RadioButtons;
	
	/**
     * ...
     * @author Cristian Zaloj
     */
    public class LECTile extends ACLevelEditorController {
        
        private var tilesList:RadioButtons = new RadioButtons(64, 64, onTileSelect);
        
        private var dragStart:Vector2i = null;
        private var selectedTile:int = -1;
        
        public function LECTile(l:Level) {
            super(l);
			addEventListener(Event.ADDED_TO_STAGE, init);
            renderSelf();
        }
        
        private function renderSelf():void {
            var tMap:Object = new Object();
            tMap["1"] = (new Embedded.DirtMergeBMP() as Bitmap).bitmapData;
            tMap["2"] = (new Embedded.WoodMergeBMP() as Bitmap).bitmapData;
            tMap["3"] = (new Embedded.MetalMergeBMP() as Bitmap).bitmapData;
            var cOpt:ConnectedSpriteOptions = new ConnectedSpriteOptions();
            cOpt.imageTileSize = 50;
            cOpt.spriteTileSize = 50;
            
            addToList(ConnectedSpriteBuilder.buildSprite([[1]], tMap, cOpt));
            addToList(ConnectedSpriteBuilder.buildSprite([[2]], tMap, cOpt));
            addToList(ConnectedSpriteBuilder.buildSprite([[3]], tMap, cOpt));
            
            var mc:MovieClip;
            mc = new Embedded.OilSWF() as MovieClip;
            mc.gotoAndStop(1);
            addToList(mc);
            mc = new Embedded.WaterBatSWF() as MovieClip;
            addToList(mc);
            mc = new Embedded.SpiderSWF() as MovieClip;
            addToList(mc);
            
            mc = new Embedded.BombSWF() as MovieClip;
            mc.gotoAndStop(1);
            addToList(mc);
            
            var pSprite:Sprite = new Sprite();
            mc = new Embedded.PlayerLegsSWF() as MovieClip;
            mc.gotoAndStop(2);
            mc.y = -5;
            pSprite.addChild(mc);
            mc = new Embedded.PlayerTorsoSWF() as MovieClip;
            mc.gotoAndStop(2);
            mc.y = -5;
            pSprite.addChild(mc);
            addToList(pSprite);
            
            
            tilesList.x = 0;
            tilesList.y = 0;
        }
        private function addToList(o:DisplayObject):void {
            // Create Background
            var back:Sprite = new Sprite();
            back.graphics.beginFill(0xffffff, 1);
            back.graphics.drawRect(0, 0, 64, 64);
            back.graphics.endFill();
            
            // Add Tile In Center
            back.addChild(o);
            o.width = 50;
            o.height = 50;
            o.x = 7;
            o.y = 7;
            
            // Add To List
            tilesList.addButton(back);
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, dispose);
            
            addChild(tilesList);
        }
        private function dispose(e:Event = null):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
            addEventListener(Event.ADDED_TO_STAGE, init);
            
            removeChild(tilesList);
        }
        
        private function onTileSelect(o:RadioButtons, i:int):void {
            
        }

        public function addTiles(i:int, x:int, y:int, w:int, h:int):void {
            var recipe:LevelRecipe = level.recipe as LevelRecipe;
            
            
        }

        override public function hookLogic() {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        override public function unhookLogic() {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function onMouseDown(e:MouseEvent = null):void {
            dragStart = getCellInLevel(e.stageX, e.stageY);
            if (dragStart.x < 0 || dragStart.x >= level.cellWidth || dragStart.y < 0 || dragStart.y >= level.cellHeight) {
                dragStart = null;
            }
        }
        private function onMouseUp(e:MouseEvent = null):void {
            if (dragStart == null) return;
            
            var dragEnd:Vector2i = getCellInLevel(e.stageX, e.stageY);
            dragEnd.x = Utils.clampI(dragEnd.x, 0, level.cellWidth - 1);
            dragEnd.y = Utils.clampI(dragEnd.y, 0, level.cellHeight - 1);
            
            var buf:int;
            if (dragEnd.x < dragStart.x) {
                buf = dragStart.x;
                dragStart.x = dragEnd.x;
                dragEnd.x = buf;
            }
            if (dragEnd.y < dragStart.y) {
                buf = dragStart.y;
                dragStart.y = dragEnd.y;
                dragEnd.y = buf;
            }
            dragEnd.SubV(dragStart).AddD(1);
            
            if (selectedTile != -1) {
                addTiles(selectedTile, dragStart.x, dragStart.y, dragEnd.x, dragEnd.y);
            }
        }
    }
}