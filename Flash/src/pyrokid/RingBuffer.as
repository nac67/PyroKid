package pyrokid {
    import flash.display.DisplayObject;
    
    /*
     Example of how to iterate through this
      
     for (var i = 0; i < level.fireballs.size(); i++) {
        var fball:Fireball = level.fireballs.get(i) as Fireball;
        // do stuff with fball...
     }
    */
    
    public class RingBuffer {
        
        private var maxItems:int;
        public var buffer:Array;
        private var head = 0;
        private var _size = 0;
        private var evictFcn:Function;
        
        //can't delete things while in iterator,
        //so we prepare them for purge, then purge
        //them after the iteration is complete
        private var markedForDel:Array;
        
        /**
         * Ring buffer!
         * @param maxItems
         * @param evictFcn callback function with one parameter. 
         *        This function gets called anytime something gets
         *        evicted. It has one parameter which is the evicted object.
         */
        public function RingBuffer(maxItems:int, evictFcn:Function=null) {
            this.maxItems = maxItems;
            buffer = new Array(maxItems);
            for (var i = 0; i < maxItems; i++) {
                buffer[i] = null;
            }
            markedForDel = [];
            this.evictFcn = evictFcn;
        }
        
        public function size():int {
            return _size;
        }
        
        public function push(o:Object):void {
            var oldHead = buffer[head];
            if (oldHead != null) {
                removeVisual(oldHead);                
            }
            
            buffer[head] = o;
            head = clamp(head + 1);
            if(_size<maxItems) _size++;
        }
        
        public function pop():Object {
            if(_size>0){
                var output:Object = buffer[tail()];
                removeVisual(buffer[tail()]);
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
        
        /**
         * While iterating through the list, you can prepare objects
         * to be removed. Since you can't remove things while iterating,
         * you do this. Objects must be prepared for deletion in order that they
         * appear in the list. I.e. if you iterate through the list, and mark things
         * for deletion in the order you encounter them it will be fine.
         * @param o
         */
        public function markForDeletion(o:Object) {
            markedForDel.push(o);
        }
        
        /**
         * After iteration, you call this to actually delete all the objects marked 
         * for deletion.
         */
        public function deleteAllMarked():void {
            var oldBuffer:Array = buffer.slice();
            var oldHead = head;
            var oldSize = _size;
            
            //reset buffer
            buffer = new Array(maxItems);
            for (var i = 0; i < maxItems; i++) {
                buffer[i] = null;
            }
            head = 0;
            _size = 0;
            
            //look through old objects, if they are not purged,
            //add them to the new buffer, if they are marked,
            //increment the markIndex, to look for the next item
            //to be purged.
            var markIndex = 0;
            for (var i = 0; i < oldSize; i++) {
                var realIndex = clamp(oldHead - oldSize+i);
                var oldObj = oldBuffer[realIndex];
                if(markedForDel[markIndex] == oldObj){
                    markIndex++;
                    removeVisual(oldObj);
                }else {
                    push(oldBuffer[realIndex]);
                }
            }
            
            markedForDel = [];
        }
        
        private function clamp(v:int):int {
            return (v+maxItems) % maxItems;
        }
        
        private function removeVisual(o:Object) {
            if (evictFcn != null) {
                evictFcn(o);
            }
        }
    
    }

}