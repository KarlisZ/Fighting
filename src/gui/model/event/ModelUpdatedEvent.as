package gui.model.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ModelUpdatedEvent extends Event
	{
		static public const NEAR_ID:String = "nearId";
		
		public function ModelUpdatedEvent(type:String) 
		{
			super(type);
		}
		
	}

}