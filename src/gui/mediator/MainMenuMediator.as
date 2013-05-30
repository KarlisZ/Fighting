package gui.mediator 
{
	import common.event.SubcontextEvent;
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
		
		public function MainMenuMediator() 
		{
			
		}
		
		override public function onRegister():void
		{
			view.addEventListener(MenuEvent.CREATE_TEST_COMBAT_STAGE, dispatchMenuEvent);
		}
		
		private function dispatchMenuEvent(e:MenuEvent):void 
		{
			dispatch(e);
		}
		
	}

}