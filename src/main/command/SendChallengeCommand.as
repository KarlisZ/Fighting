package main.command 
{
	import common.event.SubcontextEvent;
	import main.service.cirrus.data.PrivateCommandType;
	import main.service.cirrus.data.SwarmCommandType;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SendChallengeCommand  extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var event:SubcontextEvent;
		
		override public function execute():void
		{
			cirrus.smartSend(event.data.nearId, PrivateCommandType.REQUEST_COMBAT);
		}
		
	}

}