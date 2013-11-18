package gui.mediator 
{
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import common.event.SubcontextEvent;
	import gui.event.GuiEvent;
	import gui.event.MenuEvent;
	import common.factory.SubcontextEventFactory;
	import gui.model.event.ModelUpdatedEvent;
	import gui.model.GuiModel;
	import gui.view.components.event.LobbyEvent;
	import gui.view.event.LobbyContainerEvent;
	import gui.view.LobbyContainer;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LobbyContainerMediator extends Mediator
	{
		[Inject] public var view:LobbyContainer;
		[Inject] public var model:GuiModel;
		
		private var logger:ILogger = Logger.getLogger(LobbyContainerMediator);
		
		override public function onRegister():void
		{
			addContextListener(MenuEvent.JOIN_LOBBY, onShowLobby, GuiEvent);
			addContextListener(ModelUpdatedEvent.NEAR_ID, onModelUpdated, ModelUpdatedEvent);
			addContextListener(SubcontextEvent.PUBLIC_PEER_CONNECTED, onPeerConnected, SubcontextEvent);
			addContextListener(SubcontextEvent.BROADCAST_RECEIVED, onBroadcastReceived, SubcontextEvent);
			
			addViewListener(LobbyContainerEvent.JOIN_LOBBY, onJoinLobby);
			addViewListener(LobbyEvent.MESSAGE_ENTERED, onMessageEntered);
		}
		
		private function onBroadcastReceived(e:SubcontextEvent):void 
		{
			view.addPublicMessage(e.data.nearId, e.data.message);
		}
		
		private function onMessageEntered(e:LobbyEvent):void 
		{
			dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.BROADCAST, { message:e.data } ));
		}
		
		private function onPeerConnected(e:SubcontextEvent):void 
		{
			switch(e.type)
			{
				case SubcontextEvent.PUBLIC_PEER_CONNECTED:
					view.addPublicPeer(e.data.farId);
					break;
					
				case SubcontextEvent.PRIVATE_PEER_CONNECTED:
					view.addPrivatePeer(e.data.farId);
					break;
				default:;
			}
		}
		
		private function onJoinLobby(e:LobbyContainerEvent):void 
		{
			dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.CONNECT_TO_PEER, {nearId:e.data}));
		}
		
		private function onModelUpdated(e:ModelUpdatedEvent):void 
		{
			switch(e.type)
			{
				case ModelUpdatedEvent.NEAR_ID:
					view.nearId = model.nearId;
					break;
			}
		}
		
		private function onShowLobby(e:GuiEvent):void 
		{
			view.show();
			view.promptId();
		}
	}

}