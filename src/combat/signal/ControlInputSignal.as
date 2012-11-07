package combat.signal {
	import combat.data.Control;
	import combat.view.api.IFighter;
	import flash.events.KeyboardEvent;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ControlInputSignal extends Signal {
		
		public function ControlInputSignal() {
			super(KeyboardEvent, Control, IFighter);
		}
		
	}

}