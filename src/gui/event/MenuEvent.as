package gui.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MenuEvent extends Event
	{
		public static const CREATE_TEST_COMBAT_STAGE:String = 'MenuEvent.CREATE_TEST_COMBAT_STAGE';
		
		public function MenuEvent(type:String) 
		{
			super(type);
		}
		
	}

}