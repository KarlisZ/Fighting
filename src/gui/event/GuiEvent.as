package gui.event 
{
	import flash.events.Event;
	import gui.event.api.IGuiEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class GuiEvent extends Event implements IGuiEvent
	{
		public var data:*;
		
		public function GuiEvent(type:String, data:* = null) 
		{
			super(type);
			this.data = data;
			
		}
		
	}

}