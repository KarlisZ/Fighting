package gui.command 
{
	import common.event.SubcontextEvent;
	import gui.event.ConsoleEvent;
	import gui.factory.SubcontextEventFactory;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class DispatchSubcontextEventCommand extends Command
	{
		[Inject] public var consoleEvent:ConsoleEvent;
		
		override public function execute():void
		{
			if (consoleEvent)
			{
				parseConsoleEvent();
			}
		}
		
		private function parseConsoleEvent():void 
		{
			// main context listens for these
			switch (consoleEvent.type)
			{
				case ConsoleEvent.CREATE_NETWORK:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.CREATE_NETWORK));
					break;
					
				case ConsoleEvent.CONNECT_TO_PEER:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.CONNECT_TO_PEER, consoleEvent.data));
					break;
					
				case ConsoleEvent.PING_PEER:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.PING_PEER, consoleEvent.data));
					break;
					
				case ConsoleEvent.BROADCAST:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.BROADCAST, consoleEvent.data));
					break;
					
				case ConsoleEvent.REQUEST_PRIVATE_STREAM:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.REQUEST_PRIVATE_STREAM, consoleEvent.data));
					break;
			}
		}
		
	}

}