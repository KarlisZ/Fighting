package gui.context 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
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
		
		public function GuiContext(contextView:DisplayObjectContainer) 
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			mediatorMap.mapView(MainMenu, MainMenuMediator);
			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, BootstrapGuiCommand, Event, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, MapViewsCommand, Event, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, BuildGuiCommand, Event, true);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, BuildConsoleCommand, Event, true);
			
			super.startup();
		}
	}

}