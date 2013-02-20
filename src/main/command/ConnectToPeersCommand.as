package main.command 
{
	import main.model.MainModel;
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ConnectToPeersCommand extends Command
	{
		[Inject] public var cirrus:CirrusService;
		[Inject] public var model:MainModel;
		
		override public function execute():void
		{
			cirrus.connect(model.cirrusToken);
		}
		
	}

}