package {
	import flash.display.Sprite;
	import flash.events.Event;
	import main.context.MainContext;
	
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Main extends Sprite {
		private var context:MainContext;
		
		public function Main():void {
			context = new MainContext(this);
		}
		
	}
	
}