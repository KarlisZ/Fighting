package gui.view.components 
{
	import com.bit101.components.PushButton;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Member extends PushButton
	{
		public var peerId:String;
		
		public function Member(peerId:String) 
		{
			super();
			this.peerId = peerId;
			
		}
	}

}