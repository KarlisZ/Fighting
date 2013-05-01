package main.command 
{
	import common.event.SubcontextEvent;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PingPeerCommand extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var event:SubcontextEvent;
		
		override public function execute():void
		{
			cirrus.pingPeer(event.data.nearId);
		}
		
	}

}