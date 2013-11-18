package main.service.cirrus.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PeerManagerEvent extends Event
	{
		public var data:*;
		static public const PUBLIC_PEER_CONNECTED:String = "PeerManagerEvent.PUBLIC_PEER_CONNECTED";
		static public const BROADCAST_RECEIVED:String = "PeerManagerEvent.BROADCAST_RECEIVED";
		public function PeerManagerEvent(type:String, data:*) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}