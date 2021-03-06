package gui.view.components 
{
	import com.bit101.components.InputText;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import gui.view.components.event.LobbyEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Lobby extends Window
	{
		private const chat:TextArea = new TextArea();
		private const input:InputText = new InputText();
		private const members:MembersPane = new MembersPane();
		static public const DEFAULT_SIZE:Rectangle = new Rectangle(0,0,400, 500);
		
		public function Lobby(parent:DisplayObjectContainer, title:String) 
		{
			// TODO: click on member switches to private chat
			super(parent, 0, 0, title);
			build();
		}
		
		private function build():void 
		{
			addChild(chat);
			addChild(input);
			addChild(members);
			
			setSize(DEFAULT_SIZE.width, DEFAULT_SIZE.height);
			
			listenToInput();
		}
		
		private function listenToInput():void 
		{
			input.addEventListener(KeyboardEvent.KEY_UP, onInputKeyUp);
		}
		
		private function onInputKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode === Keyboard.ENTER && !e.shiftKey)
			{
				addChatMessage("[ME]: " + input.text);
				dispatchEvent(new LobbyEvent(LobbyEvent.MESSAGE_ENTERED, input.text));
				input.text = "";
			}
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			draw();
			validate();
		}
		
		public function addChatMessage(message:String):void 
		{
			chat.text += message + "\n";
		}
		
		public function addMember(farId:String):void 
		{
			members.addMember(farId);
		}
		
		private function validate():void 
		{
			const leftSideWidth:Number = _panel.width * .6;
			
			input.y = _panel.height - input.height;
			input.width = leftSideWidth;
			
			chat.height = input.y - chat.y;
			chat.width = leftSideWidth
			
			members.x = leftSideWidth;
			members.height = _panel.height - members.y;
			members.width = _panel.width - leftSideWidth;
			
		}
		
	}

}