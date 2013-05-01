package main.command 
{
	import common.event.SubcontextEvent;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CreatePrivateStream extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var event:SubcontextEvent;
		
		override public function execute():void
		{
			cirrus.createPrivateConnection(event.data.nearId);
		}
		
	}

}