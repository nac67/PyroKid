package pyrokid.tools {
    import flash.display.DisplayObject;
    
    /*
     Example of how to iterate through this
      
     for (var i = 0; i < level.fireballs.size(); i++) {
        var fball:Fireball = level.fireballs.get(i) as Fireball;
        // do stuff with fball...
        
        // here's how to mark something for eviction
        level.fireball.markForDeletion(fball);
     }
     
     // this actually deletes all things marked, after the iteration
     level.fireball.deleteAllMarked();
    */
    
    public class RingBuffer {
        
        private var maxItems:int;
        public var buffer:Array;
        private var head:int = 0;
        private var _size:int = 0;
        private var evictFcn:Function;
        
        //can't delete things while in iterator,
        //so we prepare them for purge, then purge
        //them after the iteration is complete
        private var markedForDel:HashSet;
        
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
            for (var i:int = 0; i < maxItems; i++) {
                buffer[i] = null;
            }
            markedForDel = new HashSet(true);
            this.evictFcn = evictFcn;
        }
        
        public function size():int {
            return _size;
        }
        
        public function push(o:Object):void {
            var oldHead:Object = buffer[head];
            if (oldHead != null) {
                evict(oldHead);                
            }
            
            buffer[head] = o;
            head = clamp(head + 1);
            if(_size<maxItems) _size++;
        }
        
        public function pop():Object {
            if(_size>0){
                var output:Object = buffer[tail()];
                evict(buffer[tail()]);
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
        
        // TODO isn't get a keyword? This doesn't seem valid -- Nick
        public function get(i:int):Object {
            var index:int = clamp(tail() + i);
            return buffer[index];
        }
        
        /**
         * While iterating through the list, you can prepare objects
         * to be removed. Since you can't remove things while iterating,
         * you do this.
         * @param o
         */
        public function markForDeletion(o:Object):void {
            markedForDel.add(o);
        }
        
        /**
         * After iteration, you call this to actually delete all the objects marked 
         * for deletion.
         */
        public function deleteAllMarked():void {
            var oldBuffer:Array = buffer.slice();
            var oldHead:int = head;
            var oldSize:int = _size;
            
            //reset buffer
            buffer = new Array(maxItems);
            for (var i:int = 0; i < maxItems; i++) {
                buffer[i] = null;
            }
            head = 0;
            _size = 0;
            
            //look through old objects, if they are not purged,
            //add them to the new buffer, if they are marked, purge them
            for (i = 0; i < oldSize; i++) {
                var realIndex:int = clamp(oldHead - oldSize+i);
                var oldObj:Object = oldBuffer[realIndex];
                if (markedForDel.contains(oldObj)) {
                    evict(oldObj);
                }else {
                    push(oldBuffer[realIndex]);
                }
            }
            
            markedForDel = new HashSet(true);
        }
        
        public function remove(o:Object):void {
            markForDeletion(o);
            deleteAllMarked();
        }
        
        public function contains(o:Object):Boolean {
            return buffer.indexOf(o) != -1;
        }
        
        /**
         * This is a method that goes through the structure
         * and deletes anything that doesn't match the given
         * criteria
         * @param fcn callback function that takes in item,
         * returns true of false. False means that it should
         * delete the item.
         */
        public function filter(fcn:Function):void {
            for (var i:int = 0; i < size(); i++) {
                var item:Object = get(i);
                if (!fcn(item)) {
                    markForDeletion(item);
                }
            }
            deleteAllMarked();
        }
        
        private function clamp(v:int):int {
            return (v+maxItems) % maxItems;
        }
        
        private function evict(o:Object):void {
            if (evictFcn != null) {
                evictFcn(o);
            }
        }
    
    }

}