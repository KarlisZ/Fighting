package gui.mediator 
{
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import common.event.SubcontextEvent;
	import gui.event.GuiEvent;
	import gui.event.MenuEvent;
	import gui.factory.SubcontextEventFactory;
	import gui.view.MainMenu;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MainMenuMediator extends Mediator
	{
		[Inject] public var view:MainMenu;
		
		private var logger:ILogger = Logger.getLogger(MainMenuMediator);
		
		public function MainMenuMediator() 
		{
			
		}
		
		override public function onRegister():void
		{
			view.addEventListener(MenuEvent.CREATE_TEST_COMBAT_STAGE, dispatchMenuEvent);
		}
		
		private function dispatchMenuEvent(e:MenuEvent):void 
		{
			dispatch(new GuiEvent(e.type));
		}
		
	}

}