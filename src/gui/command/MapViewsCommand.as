package gui.command 
{
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.Console;
	import gui.mediator.ConsoleMediator;
	import gui.mediator.LobbyContainerMediator;
	import gui.mediator.PopupContainerMediator;
	import gui.mediator.TestUiMediator;
	import gui.view.LobbyContainer;
	import gui.view.PopupContainer;
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
			mediatorMap.mapView(LobbyContainer, LobbyContainerMediator);
			mediatorMap.mapView(PopupContainer, PopupContainerMediator);
			
		}
		
	}

}