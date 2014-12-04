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
	[Embed(source="../../../assets/swf/buttons.swf", symbol="LevelComplete")]
	public class CompletedButton extends SimpleButton 
	{
		
		public function CompletedButton(txt:String, x:int, y:int) {
			this.x = x;
			this.y = y;
			
            Utils.findTextFieldInFlashBTN(this.upState as DisplayObjectContainer).text = txt;
            Utils.findTextFieldInFlashBTN(this.downState as DisplayObjectContainer).text = txt;
            Utils.findTextFieldInFlashBTN(this.overState as DisplayObjectContainer).text = txt;
		}
		
	}

}