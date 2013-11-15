package gui.mediator 
{
	import com.junkbyte.console.Cc;
	import gui.data.ConsoleCommandType;
	import gui.event.ConsoleEvent;
	import gui.event.GuiEvent;
	import gui.vo.ConsoleDataVo;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ConsoleMediator extends Mediator
	{
		
		public function ConsoleMediator() 
		{
			
		}
		
		override public function onRegister():void
		{
			mapCommands();
		}
		
		private function mapCommands():void 
		{
			Cc.addSlashCommand(ConsoleCommandType.CREATE_NETWORK, onCreateNetwork, 'Create a Cirrus network, become the first peer!');
			Cc.addSlashCommand(ConsoleCommandType.CONNECT_TO_PEER, onConnectToPeer, 'Connect to Cirrus P2P network, put nearId as param.');
			Cc.addSlashCommand(ConsoleCommandType.BROADCAST, onBroadcast, 'Broadcast a message to the swarm.');
			Cc.addSlashCommand(ConsoleCommandType.PING_PEER, onPing, 'Ping a member of the swarm. Takes peer ID as param.');
			Cc.addSlashCommand(ConsoleCommandType.REQUEST_PRIVATE_STREAM, onRequestPrivate, 'Create a private connection to a peer.');
			Cc.addSlashCommand(ConsoleCommandType.SEND_TO_PRIVATE, onSendToPrivate, 'Send data to a private swarm.');
		}
		
		private function onSendToPrivate(params:String):void 
		{
			var split:Array = params.split(" ");
			var data:ConsoleDataVo = new ConsoleDataVo();
			data.nearId = split[0];
			data.message = split[1];
			dispatch(new GuiEvent(ConsoleEvent.SEND_TO_PRIVATE, data));
		}
		
		private function onRequestPrivate(nearId:String):void 
		{
			var data:ConsoleDataVo = new ConsoleDataVo();
			data.nearId = nearId;
			dispatch(new GuiEvent(ConsoleEvent.REQUEST_PRIVATE_STREAM, data));
		}
		
		private function onPing(nearId:String):void 
		{
			var data:ConsoleDataVo = new ConsoleDataVo();
			data.nearId = nearId;
			dispatch(new ConsoleEvent(ConsoleEvent.PING_PEER, data));
		}
		
		private function onBroadcast(message:String):void 
		{
			var data:ConsoleDataVo = new ConsoleDataVo();
			data.message = message;
			dispatch(new GuiEvent(ConsoleEvent.BROADCAST, data));
		}
		
		private function onCreateNetwork():void 
		{
			dispatch(new GuiEvent(ConsoleEvent.CREATE_NETWORK));
			
		}
		
		private function onConnectToPeer(nearId:String):void 
		{
			var data:ConsoleDataVo = new ConsoleDataVo();
			data.nearId = nearId;
			dispatch(new GuiEvent(ConsoleEvent.CONNECT_TO_PEER, data));
		}
		
	}

}