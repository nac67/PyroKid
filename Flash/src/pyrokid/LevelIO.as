package pyrokid {
    import flash.events.*;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
 
    public class LevelIO {
		private static var loadLevelCallback:Function;
		private static var fileRef:FileReference;
		
		/* callback is a function that will be called on the loaded LevelRecipe object.
		 * Note that callback MUST expect an Object or untyped parameter, NOT a LevelRecipe
		 * parameter. This is due to the Flash compiler not knowing the unserialized object's type. */
		public static function loadLevel(callback:Function, level:ByteArray=null):void {
			loadLevelCallback = callback;
            
            if (level == null) {
                fileRef = new FileReference();
                fileRef.addEventListener(Event.SELECT, onFileSelected);
                var textTypeFilter:FileFilter = new FileFilter("Text Files", "*.txt");
                fileRef.browse([textTypeFilter]);
            } else {
                loadLevelCallback(level.readObject());
            }
		}
		
		/* Saves levelRecipe to file. levelRecipe is an Object due to the Flash compiler not being knowing
		 * an unserialized Object's type, but ONLY pass a LevelRecipe object into this method. */
		public static function saveLevel(levelRecipe:Object):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(levelRecipe);
			var fileRef:FileReference = new FileReference();
			fileRef.save(bytes);
		}

        private static function onFileSelected(evt:Event):void {
            fileRef.addEventListener(Event.COMPLETE, onComplete);
            fileRef.load();
        }
 
        private static function onComplete(evt:Event):void {
			var levelRecipe:Object = fileRef.data.readObject();
            fileRef.removeEventListener(Event.SELECT, onFileSelected);
			loadLevelCallback(levelRecipe);
        }
    } 
}