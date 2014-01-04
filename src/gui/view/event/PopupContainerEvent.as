package gui.view.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PopupContainerEvent extends Event 
	{
		public var data:*;
		
		static public const PRIVATE_STREAM_ACCEPT_CLICKED	:String = "PopupContainerEvent.PRIVATE_STREAM_ACCEPT_CLICKED";
		
		public function PopupContainerEvent(type:String, data:*) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
			
		} 
		
		public override function clone():Event 
		{ 
			return new PopupContainerEvent(type, data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PopupContainerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}