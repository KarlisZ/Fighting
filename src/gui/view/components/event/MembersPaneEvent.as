package gui.view.components.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MembersPaneEvent extends Event 
	{
		public var data:*;
		static public const CHALLENGE_CLICKED:String = "MembersPaneEvent.CHALLENGE_CLICKED";
		
		public function MembersPaneEvent(type:String, data:*) 
		{
			super(type, true);
			this.data = data;
			
		}
		
	}

}