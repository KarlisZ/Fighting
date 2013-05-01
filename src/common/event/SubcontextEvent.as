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
		
		public var data:SubcontextDataVo;
		
		public function SubcontextEvent(type:String, data:SubcontextDataVo = null) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}