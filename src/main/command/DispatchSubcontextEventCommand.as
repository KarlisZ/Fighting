package main.command 
{
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import common.event.SubcontextEvent;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class DispatchSubcontextEventCommand extends Command
	{
		
		[Inject] public var event:;
		
		private var logger:ILogger = Logger.getLogger(DispatchSubcontextEventCommand);
		
		override public function execute():void
		{
			parseEvent();
		}
		
		private function parseEvent():void 
		{
			var e:SubcontextEvent;
			
			switch (event.type)
			{
				
			}
		}
		
	}

}