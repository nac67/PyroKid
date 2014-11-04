package ui.buttons 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Evan Niederhoffer
	 */
	[Embed(source="../../../assets/swf/buttons.swf", symbol="LevelLock")]
	public class LockedButton extends ButtonBase 
	{
		
		public function LockedButton(txt:String, x:int, y:int)
		{
			this.x = x;
			this.y = y;

			((this.upState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			((this.downState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			((this.overState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			
		}
		
	}

}