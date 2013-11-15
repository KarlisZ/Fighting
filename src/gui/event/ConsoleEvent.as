package gui.event 
{
	import gui.vo.ConsoleDataVo;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ConsoleEvent extends GuiEvent
	{
		static public const CONNECT_TO_PEER:String = 'ConsoleEvent.CONNECT_TO_PEER';
		static public const CREATE_NETWORK:String = 'ConsoleEvent.CREATE_NETWORK';
		static public const BROADCAST:String = "ConsoleEvent.BROADCAST";
		static public const PING_PEER:String = "ConsoleEvent.PING_PEER";
		static public const REQUEST_PRIVATE_STREAM:String = "ConsoleEvent.REQUEST_PRIVATE_STREAM";
		static public const SEND_TO_PRIVATE:String = "ConsoleEvent.SEND_TO_PRIVATE";
		
		public function ConsoleEvent(type:String, data:ConsoleDataVo = null) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}