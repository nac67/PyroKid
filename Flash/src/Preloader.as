package  {
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import pyrokid.Constants;
    import flash.utils.getDefinitionByName;
    
    public class Preloader extends MovieClip{
        
        private var LOADER_WIDTH:int = 300;
        private var LOADER_HEIGHT:int = 30;
        
        //private var stage:Stage;
        private var callback:Function;
        
        // Loading bar
        private var outline:Sprite;
        private var fill:Sprite;
        
        
        
        public function Preloader(){//stage:Stage, callback:Function) {
            trace("bitches");
            //callback();
            //return;
            stop();
            //this.stage = stage;
            //this.callback = callback;
            
            outline = new Sprite();
            fill = new Sprite();
            
            this.addChild(outline);
            this.addChild(fill);
            
            outline.x = fill.x = Constants.WIDTH / 2 - LOADER_WIDTH/2;
            outline.y = fill.y = Constants.HEIGHT / 2 - LOADER_HEIGHT/2;
            outline.graphics.lineStyle(1, 888888);
            outline.graphics.drawRect(0, 0, LOADER_WIDTH, LOADER_HEIGHT);
            fill.graphics.beginFill(0x888888);
            fill.graphics.drawRect(0, 0, LOADER_WIDTH, LOADER_HEIGHT);
            fill.graphics.endFill();
            fill.scaleX = 0;
            
            this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
            addEventListener(Event.ENTER_FRAME, checkFrame);
            
            // check for immediate load
            onProgress(this.loaderInfo);
        }
        
        private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				endLoading();
			}
		}
        
        function onProgress(e):void {
            var loaded:int = e.bytesLoaded;
            var total:int = e.bytesTotal;
            fill.scaleX = loaded / total;
            if (loaded == total) {
                play();
            }
        }
        
        private function endLoading() {
            this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            //this.removeChild(outline);
            //this.removeChild(fill);
            //callback();
            trace("it done yo");
            var App:Class = getDefinitionByName("Main") as Class; //class of your app
            addChild(new App() as DisplayObject);
        }
    
    }

}