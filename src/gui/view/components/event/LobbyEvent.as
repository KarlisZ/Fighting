package gui.view.components.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LobbyEvent extends Event 
	{
		public var data:*;
		static public const MESSAGE_ENTERED:String = "LobbyEvent.MESSAGE_ENTERED";
		
		public function LobbyEvent(type:String, data:*) 
		{
			super(type, true);
			this.data = data;
			
		}
		
	}

}