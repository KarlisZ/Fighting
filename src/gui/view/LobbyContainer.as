package gui.view 
{
	import com.bit101.components.InputText;
	import com.bit101.components.Window;
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gui.view.components.Lobby;
	import gui.view.event.LobbyContainerEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LobbyContainer extends Sprite
	{
		public var nearId:String;
		private var logger:ILogger = Logger.getLogger(LobbyContainer);
		private var lobby:Lobby;
		
		public function LobbyContainer() 
		{
			
		}
		
		public function show():void 
		{
			visible = true;
		}
		
		public function promptId():void 
		{
			const idPrompt:Window = new Window(this, 300, 300, "Enter lobby ID");
			const input:InputText = new InputText(idPrompt);
			
			idPrompt.width =
			input.width = 500;
			
			idPrompt.height = idPrompt.titleBar.height + input.height;
			
			input.text = nearId;
			input.draw();
			input.textField.setSelection(0, nearId.length);
			//System.setClipboard(nearId);
			
			stage.focus = input.textField;
			
			input.addEventListener(KeyboardEvent.KEY_DOWN, onJoinIdEntered);
		}
		
		public function addPublicPeer(farId:String):void 
		{
			lobby.addMember(farId);
			lobby.addChatMessage("[SYSTEM] Peer joined the lobby: " + farId);
		}
		
		public function addPrivatePeer(farId:String):void 
		{
			
		}
		
		public function addPublicMessage(peerId:String, message:String):void 
		{
			lobby.addChatMessage("[" + peerId.substr(0, 4) + "]: " + message);
		}
		
		private function onJoinIdEntered(e:KeyboardEvent):void 
		{
			const input:InputText = e.currentTarget as InputText;
			const window:Window =  input.parent.parent.parent as Window;
			
			if (e.keyCode === Keyboard.ENTER)
			{
				
				if (input.text !== nearId)
				{					
					openLobby(input.text);
					dispatchEvent(new LobbyContainerEvent(LobbyContainerEvent.JOIN_LOBBY, input.text));
				}
				else
				{
					openLobby("My Lobby");
				}
				
				input.removeEventListener(KeyboardEvent.KEY_DOWN, onJoinIdEntered);
				removeChild(window);
			}
		}
		
		private function openLobby(id:String):void 
		{
			lobby = new Lobby(this, "Lobby ID: " + id);
			
			lobby.x = 150;
			lobby.y = 150;
			
			lobby.addChatMessage("[SYSTEM] Waiting for connections...");
		}
		
		
	}

}