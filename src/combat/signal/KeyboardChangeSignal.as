package combat.signal {
	import flash.events.KeyboardEvent;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class KeyboardChangeSignal extends Signal {
		
		public function KeyboardChangeSignal() {
			super(KeyboardEvent);
		}
		
	}

}