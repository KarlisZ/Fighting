package main.context
{
	import combat.command.BuildCombatViewCommand;
	import combat.context.CombatContext;
	import common.event.SubcontextEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import gui.context.GuiContext;
	import main.command.BroadcastCommand;
	import main.command.ConnectToPeerCommand;
	import main.command.CreateNetworkCommand;
	import main.command.CreatePrivateStream;
	import main.command.PingPeerCommand;
	import main.command.StartupCommand;
	import org.robotlegs.base.ContextEvent;
	//import main.event.TestEvent;
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
		private var guiContext:GuiContext;
		
		public function MainContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			combatContext = new CombatContext(contextView);
			guiContext = new GuiContext(contextView);
			
			listenToSubcontexts();
			
			injector.mapSingleton(MainModel);
			injector.mapSingleton(CirrusService);
			
			//commandMap.mapEvent(CirrusServiceEvent.CONNECTED, SendGreetingCommand, CirrusServiceEvent, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCommand, Event, true);
			commandMap.mapEvent(SubcontextEvent.CONNECT_TO_PEER, ConnectToPeerCommand, SubcontextEvent);
			commandMap.mapEvent(SubcontextEvent.CREATE_NETWORK, CreateNetworkCommand, SubcontextEvent);
			commandMap.mapEvent(SubcontextEvent.BROADCAST, BroadcastCommand, SubcontextEvent);
			commandMap.mapEvent(SubcontextEvent.PING_PEER, PingPeerCommand, SubcontextEvent);
			commandMap.mapEvent(SubcontextEvent.REQUEST_PRIVATE_STREAM, CreatePrivateStream, SubcontextEvent);
			//commandMap.mapEvent(TestEvent.SEND_DATA, SendDataCommand, TestEvent);
			
			//dispatchEvent(new Event("connectToPeers"));
			super.startup();
		}
		
		private function listenToSubcontexts():void 
		{
			guiContext.addEventListener(SubcontextEvent.CONNECT_TO_PEER, onSubcontextEvent);
			guiContext.addEventListener(SubcontextEvent.CREATE_NETWORK, onSubcontextEvent);
			guiContext.addEventListener(SubcontextEvent.BROADCAST, onSubcontextEvent);
			guiContext.addEventListener(SubcontextEvent.PING_PEER, onSubcontextEvent);
			guiContext.addEventListener(SubcontextEvent.REQUEST_PRIVATE_STREAM, onSubcontextEvent);
		}
		
		private function onSubcontextEvent(e:SubcontextEvent):void 
		{
			// need to create new event for the system to recognize it for some reason
			dispatchEvent(new SubcontextEvent(e.type, e.data));
		}
	
	}

}