package main.command 
{
	import common.event.SubcontextEvent;
	import flash.events.Event;
	import main.model.MainModel;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ConnectToPeerCommand  extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var model:MainModel;
		[Inject] public var event:SubcontextEvent;
		
		override public function execute():void
		{
			cirrus.connectToNetwork(event.data.nearId);
		}
		
	}

}