package gui.command 
{
	import gui.event.ConsoleEvent;
	import gui.model.GuiModel;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class BootstrapGuiCommand extends Command
	{
		
		override public function execute():void
		{
			injector.mapSingleton(GuiModel);
			
			// map console events
			commandMap.mapEvent(ConsoleEvent.CREATE_NETWORK, DispatchSubcontextEventCommand, ConsoleEvent);
			commandMap.mapEvent(ConsoleEvent.CONNECT_TO_PEER, DispatchSubcontextEventCommand, ConsoleEvent);
			commandMap.mapEvent(ConsoleEvent.BROADCAST, DispatchSubcontextEventCommand, ConsoleEvent);
			commandMap.mapEvent(ConsoleEvent.PING_PEER, DispatchSubcontextEventCommand, ConsoleEvent);
			commandMap.mapEvent(ConsoleEvent.REQUEST_PRIVATE_STREAM, DispatchSubcontextEventCommand, ConsoleEvent);
		}
		
	}

}