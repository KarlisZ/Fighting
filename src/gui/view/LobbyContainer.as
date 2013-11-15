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
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LobbyContainer extends Sprite
	{
		private var logger:ILogger = Logger.getLogger(LobbyContainer);
		
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
			input.width = 300;
			
			idPrompt.height = idPrompt.titleBar.height + input.height;
			
			stage.focus = input.textField;
			
			input.addEventListener(KeyboardEvent.KEY_DOWN, onJoinIdEntered);
		}
		
		private function onJoinIdEntered(e:KeyboardEvent):void 
		{
			const input:InputText = e.currentTarget as InputText;
			const window:Window =  input.parent.parent.parent as Window;
			
			if (e.keyCode === Keyboard.ENTER)
			{
				openLobby(input.text);
				
				input.removeEventListener(KeyboardEvent.KEY_DOWN, onJoinIdEntered);
				removeChild(window);
			}
		}
		
		private function openLobby(id:String):void 
		{
			const lobby:Lobby = new Lobby(this, "Lobby ID: " + id);
			
			lobby.x = 150;
			lobby.y = 150;
		}
		
	}

}