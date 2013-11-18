package gui.model 
{
	import flash.display.Sprite;
	import gui.model.event.ModelUpdatedEvent;
	import org.robotlegs.mvcs.Actor;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class GuiModel extends Actor
	{
		public var mainMenu:Sprite;
		private var _nearId:String;
		
		public function GuiModel() 
		{
			
		}
		
		public function get nearId():String 
		{
			return _nearId;
		}
		
		public function set nearId(value:String):void 
		{
			_nearId = value;
			dispatch(new ModelUpdatedEvent(ModelUpdatedEvent.NEAR_ID));
		}
		
	}

}