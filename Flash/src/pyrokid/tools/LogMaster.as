package pyrokid.tools {
    import pyrokid.Constants;
    
    public class LogMaster {
        
        private var logging:Logging;
        private var currLevel:int;
        
        public function LogMaster() {
            logging = new Logging(Constants.TEAM_ID, Constants.VERSION_ID, !Constants.DO_LOGGING);
            logging.recordPageLoad();
            
            //if (Constants.DO_LOGGING) {
                //var proposed_version:int = Math.floor(Math.random() * 2);
                //Constants.IS_VERSION_A = logging.recordABTestValue(proposed_version) == 0;
            //} else {
                //Constants.IS_VERSION_A = false;
            //}
            Constants.IS_VERSION_A = true;
            currLevel = -1;
        }
        
        public function logBeginLevel(num:int):void {
            if (currLevel == -1) {
                currLevel = num;
                //trace("begin level " + num);
                logging.recordLevelStart(num);
            } else if (!Constants.LEVEL_EDITOR_ENABLED) {
                trace(Constants.ERROR_MESSAGE + "beginLevel");
            }
        }
        
        public function logEndLevel():void {
            if (currLevel != -1) {
                currLevel = -1;
                //trace("level end");
                logging.recordLevelEnd();
            } else if (!Constants.LEVEL_EDITOR_ENABLED) {
                trace(Constants.ERROR_MESSAGE + "endLevel");
            }
        }
        
        public function logDeath(cellX:int, cellY:int, method:String, frameCount:int):void {
            logEvent(1, "death: " + cellX + "," + cellY + "," + method + "," + frameCount);
        }
        
        public function logFireballIgnite(cellX:int, cellY:int, type:String = ""):void {
            //logEvent(2, "fball: " + cellX + "," + cellY + "," + type);
        }
        
        public function logEvent(action:int, msg:String):void {
            if (currLevel != -1) {
                //trace(msg);
                logging.recordEvent(currLevel, action, msg);
            } else if (!Constants.LEVEL_EDITOR_ENABLED) {
                trace( Constants.ERROR_MESSAGE + "logEvent");
            }
        }
        
    
    }

}