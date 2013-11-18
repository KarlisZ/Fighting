package gui.view.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LobbyContainerEvent extends Event 
	{
		public var data:*;
		static public const JOIN_LOBBY:String = "LobbyContainerEvent.JOIN_LOBBY";
		
		public function LobbyContainerEvent(type:String, data:*) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}