package gui.mediator 
{
	import common.event.SubcontextEvent;
	import common.factory.SubcontextEventFactory;
	import gui.view.event.PopupContainerEvent;
	import gui.view.PopupContainer;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PopupContainerMediator extends Mediator
	{
		[Inject] public var view:PopupContainer;
		
		override public function onRegister():void
		{
			addContextListener(SubcontextEvent.REQUEST_PRIVATE_STREAM_RECEIVED, onSubcontextEvent);
		}
		
		private function onSubcontextEvent(e:SubcontextEvent):void 
		{
			switch (e.type)
			{
				case SubcontextEvent.REQUEST_PRIVATE_STREAM_RECEIVED:
					view.promptPrivateStream(e.data.nearId);
					addViewListener(PopupContainerEvent.PRIVATE_STREAM_ACCEPT_CLICKED, onPrivateStreamAccepted, PopupContainerEvent);
					break;
				
				default:;
			}
		}
		
		private function onPrivateStreamAccepted(e:PopupContainerEvent):void 
		{
			removeViewListener(PopupContainerEvent.PRIVATE_STREAM_ACCEPT_CLICKED, onPrivateStreamAccepted, PopupContainerEvent);
			dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.PRIVATE_STREAM_ACCEPTED, e.data));
		}
		
	}

}