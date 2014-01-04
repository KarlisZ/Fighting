package gui.context 
{
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import common.event.SubcontextEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import gui.command.BootstrapGuiCommand;
	import gui.command.BuildConsoleCommand;
	import gui.command.BuildGuiCommand;
	import gui.command.MapViewsCommand;
	import gui.mediator.MainMenuMediator;
	import gui.view.MainMenu;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class GuiContext extends Context
	{
		private var mainDispatcher:IEventDispatcher;
		private var logger:ILogger = Logger.getLogger(GuiContext);
		public function GuiContext(contextView:DisplayObjectContainer, mainDispatcher:IEventDispatcher) 
		{
			this.mainDispatcher = mainDispatcher;
			super(contextView);
			
		}
		
		override public function startup():void
		{
			mediatorMap.mapView(MainMenu, MainMenuMediator);
			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, BootstrapGuiCommand, Event, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, MapViewsCommand, Event, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, BuildGuiCommand, Event, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, BuildConsoleCommand, Event, true);
			
			listenToMainContext();
			
			super.startup();
		}
		
		private function listenToMainContext():void 
		{
			mainDispatcher.addEventListener(SubcontextEvent.NEAR_ID_KNOWN, onSubcontextEvent);
			mainDispatcher.addEventListener(SubcontextEvent.PUBLIC_PEER_CONNECTED, onSubcontextEvent);
			mainDispatcher.addEventListener(SubcontextEvent.BROADCAST_RECEIVED, onSubcontextEvent);
			mainDispatcher.addEventListener(SubcontextEvent.REQUEST_PRIVATE_STREAM_RECEIVED, onSubcontextEvent);
		}
		
		private function onSubcontextEvent(e:SubcontextEvent):void 
		{
			logger.log(e);
			dispatchEvent(new SubcontextEvent(e.type, e.data));
		}
	}

}