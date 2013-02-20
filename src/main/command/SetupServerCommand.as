package main.command 
{
	import main.service.CirrusService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SetupServerCommand extends Command
	{
		
		[Inject] public var cirrus:CirrusService;
		
		override public function execute():void
		{
			cirrus.connect();
		}
		
	}

}