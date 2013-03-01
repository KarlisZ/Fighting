package main.command 
{
	import flash.events.Event;
	import main.model.MainModel;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ConnectToNetworkCommand  extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var model:MainModel;
		
		override public function execute():void
		{
			cirrus.connectToNetwork(model.cirrusToken);
		}
		
	}

}