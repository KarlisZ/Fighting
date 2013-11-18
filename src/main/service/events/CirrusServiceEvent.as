package main.service.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CirrusServiceEvent extends Event
	{
		public static const CONNECTED_TO_PEER:String = 'CirrusServiceEvent.CONNECTED_TO_PEER';
		static public const CONNECTED_TO_CIRRUS:String = "CirrusServiceEvent.CONNECTED_TO_CIRRUS";
		
		public function CirrusServiceEvent(type:String) 
		{
			super(type);
		}
		
	}

}