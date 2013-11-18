package gui.view.components 
{
	import com.bit101.components.ScrollPane;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import gui.view.components.event.MembersPaneEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MembersPane extends ScrollPane
	{
		private var allMembers:Vector.<Member> = new Vector.<Member>();
		
		public function MembersPane() 
		{
		}
		
		public function addMember(peerId:String):void 
		{
			const newMember:Member = new Member(peerId);
			newMember.label = peerId;
			allMembers.push(newMember);
			addChild(newMember);
			draw();
			
			const menu:ContextMenu = new ContextMenu(); 
			menu.hideBuiltInItems();
			
			const challengeItem:ContextMenuItem = new ContextMenuItem("Send Challenge");
			challengeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onChallengeClicked);
			menu.customItems.push(challengeItem);
			newMember.contextMenu = menu;
		}
		
		private function onChallengeClicked(e:ContextMenuEvent):void 
		{
			const challengerId:String = (e.mouseTarget as Member).peerId;
			dispatchEvent(new MembersPaneEvent(MembersPaneEvent.CHALLENGE_CLICKED, challengerId));
		}
		
		override public function draw():void
		{
			super.draw();
			placeMembers();
		}
		
		private function placeMembers():void 
		{
			var member:Member,
				l:int = allMembers.length;
			for (var i:int = 0; i < l; i++) 
			{
				member = allMembers[i];
				member.y = member.height * i;
				member.width = _hScrollbar.x;
			}
		}
		
	}

}