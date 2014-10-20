package pyrokid.tools {
    import flash.utils.Dictionary;
    
    /* Maintains a set of objects with no duplicates.
     * 
     * HashSet can be used in two ways.
     * Method 1). Objects will be identified by their toString method. This
     *     is the default, and every element in the set must implement toString.
     *     If you add multiple items with the same toString output, only the
     *     second one will remain in the set.
     * Method 2). Objects will be identified by their identity (in computer memory).
     *     To use this method, create the HashSet with true passed into the
     *     constructor: new HashSet(true)
     * 
     *     NOTE: I do not know if as3 has the equivalent of Java's equals method
     *     or if it does, how Dictionaries respond to such a method. Therefore,
     *     this HashSet has undefined behavior if you use Method 2 and implement
     *     some sort of equals method.
     * 
     * To loop through the set, use this syntax:
     *     for each (var element:ObjType in hashSet) { ... }
     * */
    public dynamic class HashSet extends Dictionary {
        
        private var identity:Boolean;
        
        public function HashSet(useObjectIdentity:Boolean = false) {
            identity = useObjectIdentity;
        }
       
        public function add(element):void {
            if (element == null) {
                throw new Error("Cannot use null in HashSet");
            }
            this[getKey(element)] = element;
        }
        
        public function remove(element):void {
            if (element == null) {
                throw new Error("Cannot use null in HashSet");
            }
            delete this[getKey(element)];
        }
        
        public function contains(element):Boolean {
            if (element == null) {
                throw new Error("Cannot use null in HashSet");
            }
            return this[getKey(element)] != undefined;
        }
        
        public function toArray():Array {
            var arr:Array = [];
            for each (var element in this) {
                arr.push(element);
            }
            return arr;
        }
        
        private function getKey(element) {
            return identity ? element : element.toString();
        }
        
    }
    
}