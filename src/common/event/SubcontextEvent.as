package common.event 
{
	import common.vo.SubcontextDataVo;
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SubcontextEvent extends Event
	{
		public static const CONNECT_TO_PEER:String = 'SubcontextEvent.CONNECT_TO_PEER';
		public static const CREATE_NETWORK:String = 'SubcontextEvent.CREATE_NETWORK';
		static public const BROADCAST:String = "SubcontextEvent.BROADCAST";
		static public const PING_PEER:String = "SubcontextEvent.PING_PEER";
		static public const REQUEST_PRIVATE_STREAM:String = "SubcontextEvent.REQUEST_PRIVATE_STREAM";
		static public const SEND_TO_PRIVATE:String = "SubcontextEvent.SEND_TO_PRIVATE";
		static public const CREATE_TEST_COMBAT_STAGE:String = "SubcontextEvent.CREATE_TEST_COMBAT_STAGE";
		static public const NEAR_ID_KNOWN:String = "SubcontextEvent.NEAR_ID_KNOWN";
		static public const PUBLIC_PEER_CONNECTED:String = "SubcontextEvent.PUBLIC_PEER_CONNECTED";
		static public const PRIVATE_PEER_CONNECTED:String = "SubcontextEvent.PRIVATE_PEER_CONNECTED";
		static public const BROADCAST_RECEIVED:String = "SubcontextEvent.BROADCAST_RECEIVED";
		static public const CHALLENGER_SELECTED:String = "SubcontextEvent.CHALLENGER_SELECTED";
		static public const REQUEST_PRIVATE_STREAM_RECEIVED:String = "SubcontextEvent.REQUEST_PRIVATE_STREAM_RECEIVED";
		static public const PRIVATE_STREAM_ACCEPTED:String = "SubcontextEvent.PRIVATE_STREAM_ACCEPTED";
		
		public var data:SubcontextDataVo;
		
		public function SubcontextEvent(type:String, data:SubcontextDataVo = null) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}