package gui.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class TestEvent extends Event
	{
		public static const CONNECT_TO_NETWORK:String = 'TestEvent.CONNECT_TO_NETWORK';
		public static const CREATE_NETWORK:String = 'TestEvent.CREATE_NETWORK';
		public static const SEND_DATA:String = 'TestEvent.SEND_DATA';
		
		public var data:*;
		
		public function TestEvent(type:String, data:* = null) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}