package combat.engine.events 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.events.Event;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ContactEvent extends Event
	{
		public static const FIGHTER_CONTACT:String = "ContactEvent.FIGHTER_CONTACT";
		
		public var contact:b2Contact;
		
		public function ContactEvent(type:String, contact:b2Contact) 
		{
			this.contact = contact;
			super(type);
		}
		
	}

}