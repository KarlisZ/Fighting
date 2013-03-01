package main.command 
{
	import main.event.TestEvent;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SendDataCommand extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var event:TestEvent;
		
		override public function execute():void
		{
			cirrus.send(event.data);
		}
		
	}

}