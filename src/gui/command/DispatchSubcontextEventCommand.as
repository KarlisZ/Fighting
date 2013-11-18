package gui.command 
{
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import common.event.SubcontextEvent;
	import gui.event.api.IGuiEvent;
	import gui.event.ConsoleEvent;
	import gui.event.GuiEvent;
	import gui.event.MenuEvent;
	import common.factory.SubcontextEventFactory;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class DispatchSubcontextEventCommand extends Command
	{
		[Inject] public var event:GuiEvent;
		
		private var logger:ILogger = Logger.getLogger(DispatchSubcontextEventCommand);
		
		override public function execute():void
		{
			parseEvent();
		}
		
		private function parseEvent():void 
		{
			var e:SubcontextEvent;
			// main context listens for these
			switch (event.type)
			{
				case MenuEvent.CREATE_TEST_COMBAT_STAGE:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.CREATE_TEST_COMBAT_STAGE);
					break;				
				
				case ConsoleEvent.CREATE_NETWORK:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.CREATE_NETWORK);
					break;
					
				case ConsoleEvent.CONNECT_TO_PEER:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.CONNECT_TO_PEER, event.data);
					break;
					
				case ConsoleEvent.PING_PEER:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.PING_PEER, event.data);
					break;
					
				case ConsoleEvent.BROADCAST:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.BROADCAST, event.data);
					break;
					
				case ConsoleEvent.REQUEST_PRIVATE_STREAM:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.REQUEST_PRIVATE_STREAM, event.data);
					break;
					
				case ConsoleEvent.SEND_TO_PRIVATE:
					e = SubcontextEventFactory.produceEvent(SubcontextEvent.SEND_TO_PRIVATE, event.data);
					break;
			}
			
			logger.log("dispatching", e);
			dispatch(e);
			
		}
		
	}

}