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
		static public const REQUEST_PRIVATE_STREAM_RECIEVED:String = "PeerManagerEvent.REQUEST_PRIVATE_STREAM_RECIEVED";
		static public const PRIVATE_CONNECTION_ESTABLISHED:String = "PeerManagerEvent.PRIVATE_CONNECTION_ESTABLISHED";
		static public const PRIVATE_DATA_RECEIVED:String = "PeerManagerEvent.PRIVATE_DATA_RECEIVED";
		
		public function PeerManagerEvent(type:String, data:*) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}