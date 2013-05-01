package main.service.cirrus.data 
{
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SwarmCommandType 
	{
		
		public static const BROADCAST					:String = 'BROADCAST';
		public static const CREATE_PRIVATE_CONNECTION	:String = 'CREATE_PRIVATE_CONNECTION';
		static public const PING						:String = 'PING';
		static public const REPLY_TO_PING				:String = 'REPLY_TO_PING';
		static public const ADD_PEER					:String = 'ADD_PEER';
	}

}