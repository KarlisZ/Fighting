package gui.view.components 
{
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Popup extends Window
	{
		public var data:*;
		private var allButtons:Vector.<PushButton> = new Vector.<PushButton>();
		private var messageTxt:Text;
		
		public function Popup() 
		{
			build();
		}
		
		private function build():void 
		{
			messageTxt = new Text(this);
			
			
		}
		
		public function addButton(label:String, willDismiss:Boolean = true):void 
		{
			const newBtn:PushButton = new PushButton(this);
			newBtn.label = label;
			allButtons.push(newBtn);
			
			if(willDismiss)
				newBtn.addEventListener(MouseEvent.CLICK, onClose, false, int.MIN_VALUE);
			
		}
		
		public function set message(value:String):void 
		{
			messageTxt.text = value;
		}
		
		override protected function onInvalidate(event:Event):void
		{
			messageTxt.width = content.width;
			messageTxt.height = content.height;
			
			const buttonSpacing:Number = 10;
			var totalWidth:Number = buttonSpacing * (allButtons.length -1),
				nullX:Number;
			for each (var button:PushButton in allButtons)
				totalWidth += button.width;
			
			nullX = (content.width - totalWidth) * .5;
			totalWidth = 0;
			for each (button in allButtons)
			{
				button.x = nullX + totalWidth;
				button.y = messageTxt.height;
				totalWidth += button.width + buttonSpacing;
			}
			
			super.onInvalidate(event);
		}
		
	}

}