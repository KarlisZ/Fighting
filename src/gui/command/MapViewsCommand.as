package gui.command 
{
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.Console;
	import gui.mediator.ConsoleMediator;
	import gui.mediator.TestUiMediator;
	import gui.view.TestUi;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MapViewsCommand extends Command
	{
		
		override public function execute():void 
		{
			//mediatorMap.mapView(TestUi, TestUiMediator);
			mediatorMap.mapView(Console, ConsoleMediator);
			
		}
		
	}

}