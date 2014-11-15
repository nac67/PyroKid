package pyrokid.tools {
    import flash.utils.Dictionary;
    import flash.utils.*;
    
    /** Example of using this class:
     *  Only do this once: benchmarker = new Benchmarker(["phase1", "phase2"], 120)
     *  Do this inside the update loop:
     *  
     *  benchmarker.beginFrame();
     *  benchmarker.beginPhase("phase1");
     *  // execute phase 1
     *  benchmarker.endPhase();
     *  benchmarker.beginPhase("phase2");
     *  // execute phase 2
     *  benchmarker.endPhase();
     *  benchmarker.endFrame();
     * */
    public class Benchmarker {
        
        private var curFrame:int;
        private var beginFrameTime:int;
        private var beginPhaseTime:int;
        private var curPhase:String;
        private var numExecutionsByPhase:Dictionary;
        private var averageTimeByPhase:Dictionary;
        private var timeBetweenPrint:int;
        private var phaseList:Array;
        
        /** phaseList is an array of strings of all the phases that will be benchmarked.
         *  It can contain extra phases you do not use, but if you are going to use a
         *  phase, it must be in phaseList. timeBetweenAnalysis is how frequently the
         *  benchmarker will calculate and print out averages of each phase and of the
         *  entire frame. -1 will disable the benchmarker, 1 will print every frame, and
         *  n will print every n frames. */
        public function Benchmarker(phaseList:Array, timeBetweenAnalysis:int = -1) {
            timeBetweenPrint = timeBetweenAnalysis;
            this.phaseList = phaseList;
            initializeDictionaries();
            curFrame = 0;
        }
        
        private function initializeDictionaries():void {
            numExecutionsByPhase = new Dictionary();
            averageTimeByPhase = new Dictionary();
            for each (var phase:String in phaseList) {
                numExecutionsByPhase[phase] = 0;
                averageTimeByPhase[phase] = 0;
            }
            numExecutionsByPhase["ENTIRE_FRAME"] = 0;
            averageTimeByPhase["ENTIRE_FRAME"] = 0;
        }
        
        public function beginFrame():void {
            curFrame += 1;
            beginFrameTime = getTimer();
        }
        
        public function beginPhase(phase:String):void {
            curPhase = phase;
            beginPhaseTime = getTimer();
        }
        
        public function endPhase():void {
            updateAverage(curPhase, getTimer() - beginPhaseTime);
            curPhase = null;
        }
        
        private function updateAverage(key:String, timePassed:int):void {
            var numExecutions = numExecutionsByPhase[key];
            averageTimeByPhase[key] = (averageTimeByPhase[key] * numExecutions + timePassed) / (numExecutions + 1);
            numExecutionsByPhase[key] = numExecutions + 1;
        }
        
        public function endFrame():void {
            updateAverage("ENTIRE_FRAME", getTimer() - beginFrameTime);
            if (timeBetweenPrint != -1 && curFrame % timeBetweenPrint == 0) {
                for (var phase:String in averageTimeByPhase) {
                    trace("average time for phase " + phase + " is: " + averageTimeByPhase[phase]);
                }
                initializeDictionaries();
            }
        }
    }
    
}