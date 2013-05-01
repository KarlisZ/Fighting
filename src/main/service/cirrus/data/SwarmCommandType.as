package main.service.cirrus.data 
{
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SwarmCommandType 
	{
		
		public static const PARSE_BROADCAST				:String = 'BROADCAST';
		public static const CREATE_PRIVATE_CONNECTION	:String = 'CREATE_PRIVATE_CONNECTION';
		static public const REPLY_TO_PING				:String = 'REPLY_TO_PING';
		static public const PARSE_PING_REPLY			:String = 'PARSE_PING_REPLY';
		static public const ADD_PEER					:String = 'ADD_PEER';
		static public const PARSE_PRIVATE_DATA			:String = "PARSE_PRIVATE_DATA";
	}

}