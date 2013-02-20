package combat.engine.listeners 
{
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import combat.engine.events.ContactEvent;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class FighterContactListener extends b2ContactListener
	{
		public var eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public function FighterContactListener() 
		{
			
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			var fixtureA:b2Fixture = contact.GetFixtureA();
			var fixtureB:b2Fixture = contact.GetFixtureB();
			var userDataA:Object = fixtureA.GetBody().GetUserData();
			var userDataB:Object = fixtureB.GetBody().GetUserData();
			
			if	(
					userDataA.container &&
					userDataB.container &&
					userDataA.container != userDataB.container
				)
			{				
				eventDispatcher.dispatchEvent(new ContactEvent(ContactEvent.FIGHTER_CONTACT, contact));
			}
		}
	}

}