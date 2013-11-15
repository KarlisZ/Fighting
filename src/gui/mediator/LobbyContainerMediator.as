package gui.mediator 
{
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import gui.event.GuiEvent;
	import gui.event.MenuEvent;
	import gui.view.LobbyContainer;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LobbyContainerMediator extends Mediator
	{
		[Inject] public var view:LobbyContainer;
		
		private var logger:ILogger = Logger.getLogger(LobbyContainerMediator);
		
		override public function onRegister():void
		{
			addContextListener(MenuEvent.JOIN_LOBBY, onJoinLobby, GuiEvent);
		}
		
		private function onJoinLobby(e:GuiEvent):void 
		{
			view.show();
			view.promptId();
		}
	}

}