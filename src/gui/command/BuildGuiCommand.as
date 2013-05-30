package gui.command 
{
	import gui.model.GuiModel;
	import gui.view.MainMenu;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class BuildGuiCommand extends Command
	{
		[Inject] public var model:GuiModel;
		
		override public function execute():void
		{
			var mainMenu:MainMenu = new MainMenu();
			model.mainMenu = mainMenu;
			
			contextView.addChild(mainMenu);
		}
		
	}

}