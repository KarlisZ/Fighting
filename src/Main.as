package {
	import flash.display.Sprite;
	import flash.events.Event;
	import main.context.MainContext;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	[SWF(width='1200', height='800', fps='40')]
	public class Main extends Sprite {
		private var context:MainContext;
		
		public function Main():void {
			context = new MainContext(this);
		}
		
	}
	
}