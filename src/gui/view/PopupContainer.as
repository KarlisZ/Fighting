package gui.view 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gui.mediator.PopupContainerMediator;
	import gui.view.components.Popup;
	import gui.view.event.PopupContainerEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PopupContainer extends Sprite
	{
		
		public function PopupContainer() 
		{
			
		}
		
		public function promptPrivateStream(peerId:String):void 
		{
			const popup:Popup = createPopup("Peer " + peerId + " has requested a private connection");
			const acceptBtn:DisplayObject = popup.addButton("Accept") as DisplayObject;
			popup.addButton("Ignore") as DisplayObject;
			
			popup.data = peerId;
			
			acceptBtn.addEventListener(MouseEvent.CLICK, onAcceptClicked);
			
			addChild(popup);
		}
		
		private function onAcceptClicked(e:MouseEvent):void 
		{
			const tg:Popup = e.currentTarget.parent as Popup;
			dispatchEvent(new PopupContainerEvent(PopupContainerEvent.PRIVATE_STREAM_ACCEPT_CLICKED, tg.data));
		}
		
		private function createPopup(message:String):Popup 
		{
			const popup:Popup = new Popup();
			popup.title = "Input required";
			popup.message = message;
			return popup;
		}
		
	}

}