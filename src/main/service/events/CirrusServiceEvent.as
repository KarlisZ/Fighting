package main.service.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CirrusServiceEvent extends Event
	{
		public static const CONNECTED:String = 'CirrusServiceEvent.CONNECTED';
		
		public function CirrusServiceEvent(type:String) 
		{
			super(type);
		}
		
	}

}