package gui.command 
{
	import common.event.SubcontextEvent;
	import gui.event.api.IGuiEvent;
	import gui.event.ConsoleEvent;
	import gui.event.MenuEvent;
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
			commandMap.mapEvent(ConsoleEvent.CREATE_NETWORK, DispatchSubcontextEventCommand, IGuiEvent);
			commandMap.mapEvent(ConsoleEvent.CONNECT_TO_PEER, DispatchSubcontextEventCommand, IGuiEvent);
			commandMap.mapEvent(ConsoleEvent.BROADCAST, DispatchSubcontextEventCommand, IGuiEvent);
			commandMap.mapEvent(ConsoleEvent.PING_PEER, DispatchSubcontextEventCommand, IGuiEvent);
			commandMap.mapEvent(ConsoleEvent.REQUEST_PRIVATE_STREAM, DispatchSubcontextEventCommand, IGuiEvent);
			commandMap.mapEvent(ConsoleEvent.SEND_TO_PRIVATE, DispatchSubcontextEventCommand, IGuiEvent);
			
			commandMap.mapEvent(MenuEvent.CREATE_TEST_COMBAT_STAGE, DispatchSubcontextEventCommand, IGuiEvent);
			
			// subcontexts
			commandMap.mapEvent(SubcontextEvent.NEAR_ID_KNOWN, HandleSubcontextEvent, SubcontextEvent);
		}
		
	}

}