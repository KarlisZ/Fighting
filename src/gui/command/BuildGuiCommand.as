package gui.command 
{
	import gui.model.GuiModel;
	import gui.view.LobbyContainer;
	import gui.view.MainMenu;
	import gui.view.PopupContainer;
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
			const mainMenu:MainMenu = new MainMenu();
			model.mainMenu = mainMenu;
			
			const lobby:LobbyContainer = new LobbyContainer();
			
			const popups:PopupContainer = new PopupContainer();
			
			contextView.addChild(lobby);
			contextView.addChild(mainMenu);
			contextView.addChild(popups);
		}
		
	}

}