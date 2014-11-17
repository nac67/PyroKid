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
	[Embed(source="../../../assets/swf/buttons.swf", symbol="LevelUnlock")]
	public class CompletedButton extends ButtonBase 
	{
		
		public function CompletedButton(txt:String, x:int, y:int) {
			txt = txt + "+"
			
			this.x = x;
			this.y = y;
			
			(this.upState as TextField).text = txt;
			((this.downState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			((this.overState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			
		
		}
		
	}

}