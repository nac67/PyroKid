package pyrokid.tools {
    import pyrokid.Constants;
    
    public class LogMaster {
        
        private var logging:Logging;
        private var currLevel:int;
        
        public function LogMaster() {
            logging = new Logging(Constants.TEAM_ID, Constants.VERSION_ID, !Constants.DO_LOGGING);
            logging.recordPageLoad();
            currLevel = -1;
        }
        
        public function logBeginLevel(num:int):void {
            if (currLevel == -1) {
                currLevel = num;
                //trace("begin level " + num);
                logging.recordLevelStart(num);
            } else {
                trace(Constants.ERROR_MESSAGE + "beginLevel");
            }
        }
        
        public function logEndLevel():void {
            if (currLevel != -1) {
                currLevel = -1;
                //trace("level end");
                logging.recordLevelEnd();
            } else {
                trace(Constants.ERROR_MESSAGE + "endLevel");
            }
        }
        
        public function logDeath(cellX:int, cellY:int, method:String, frameCount:int):void {
            logEvent(1, "death: " + cellX + "," + cellY + "," + method + "," + frameCount);
        }
        
        public function logFireballIgnite(cellX:int, cellY:int, type:String = ""):void {
            logEvent(2, "fball: " + cellX + "," + cellY + "," + type);
        }
        
        private function logEvent(action:int, msg:String):void {
            if (currLevel != -1) {
                //trace(msg);
                logging.recordEvent(currLevel, action, msg);
            } else {
                trace( Constants.ERROR_MESSAGE + "logEvent");
            }
        }
        
    
    }

}