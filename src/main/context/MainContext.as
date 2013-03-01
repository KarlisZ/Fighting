package main.context
{
	import combat.command.BuildCombatViewCommand;
	import combat.context.CombatContext;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import main.command.ConnectToNetworkCommand;
	import main.command.CreateNetworkCommand;
	import main.command.SendDataCommand;
	import main.command.StartupCommand;
	import main.event.TestEvent;
	import main.model.MainModel;
	import main.service.CirrusService;
	import main.service.events.CirrusServiceEvent;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MainContext extends Context
	{
		private var combatContext:CombatContext;
		
		public function MainContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			combatContext = new CombatContext(contextView);
			
			injector.mapSingleton(MainModel);
			injector.mapSingleton(CirrusService);
			
			//commandMap.mapEvent(CirrusServiceEvent.CONNECTED, SendGreetingCommand, CirrusServiceEvent, true);
			commandMap.mapEvent("startupComplete", StartupCommand, Event, true);
			commandMap.mapEvent(TestEvent.CONNECT_TO_NETWORK, ConnectToNetworkCommand, TestEvent, true);
			commandMap.mapEvent(TestEvent.CREATE_NETWORK, CreateNetworkCommand, TestEvent, true);
			commandMap.mapEvent(TestEvent.SEND_DATA, SendDataCommand, TestEvent);
			
			//dispatchEvent(new Event("connectToPeers"));
			super.startup();
		}
	
	}

}