package pyrokid {
    import flash.display.DisplayObject;
    
    public class RingBuffer {
        
        private var maxItems:int;
        private var buffer:Array;
        private var head = 0;
        private var _size = 0;
        
        public function RingBuffer(maxItems:int) {
            this.maxItems = maxItems;
            buffer = new Array(maxItems);
            for (var i = 0; i < maxItems; i++) {
                buffer[i] = null;
            }
        }
        
        public function size():int {
            return _size;
        }
        
        public function push(o:Object):void {
            var oldHead = buffer[head];
            if (oldHead != null) {
                destroy(oldHead);                
            }
            
            buffer[head] = o;
            head = clamp(head + 1);
            if(_size<maxItems) _size++;
        }
        
        public function pop():Object {
            if(_size>0){
                var output:Object = buffer[tail()];
                destroy(buffer[tail()]);
                buffer[tail()] = null;
                _size--;
                return output;
            } else {
                return null;
            }
        }
        
        public function peek():Object {
            if(_size>0){
                return buffer[tail()];
            } else {
                return null;
            }
        }
        
        private function tail():int {
            return clamp(head - _size);
        }
        
        public function get(i:int):Object {
            var index:int = clamp(tail() + i);
            return buffer[index];
        }
        
        private function clamp(v:int):int {
            return (v+maxItems) % maxItems;
        }
        
        private function destroy(o:Object) {
            if (o is DisplayObject) {
                var dispObj:DisplayObject = o as DisplayObject;
                dispObj.parent.removeChild(dispObj);
            }
        }
    
    }

}