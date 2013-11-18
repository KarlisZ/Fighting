package gui.view.components 
{
	import com.bit101.components.ScrollPane;
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
		
		public function addMember(farId:String):void 
		{
			const newMember:Member = new Member();
			newMember.label = farId;
			allMembers.push(newMember);
			addChild(newMember);
			draw();
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
				member.width = _background.width;
			}
		}
		
	}

}