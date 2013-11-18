package gui.command 
{
	import common.event.SubcontextEvent;
	import gui.model.GuiModel;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class HandleSubcontextEvent extends Command
	{
		[Inject] public var event:SubcontextEvent;
		[Inject] public var model:GuiModel;
		
		override public function execute():void
		{
			switch(event.type)
			{
				case SubcontextEvent.NEAR_ID_KNOWN:
					model.nearId = event.data.nearId;
					break;
					
				default:;
			}
			
			
		}
		
	}

}