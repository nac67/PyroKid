package ui.buttons {
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.TextEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[Embed(source = "../../../assets/swf/buttons.swf", symbol = "MenuButton")]
	public class MenuButton extends ButtonBase {
		

		public function MenuButton (txt:String, x:int, y:int) 
		{
			
			this.x = x;
			this.y = y;

			(this.upState as TextField).text = txt;
			((this.downState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			((this.overState as DisplayObjectContainer).getChildAt(1) as TextField).text = txt;
			
		}
		
	}

}