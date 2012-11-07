package combat.signal {
	import combat.view.ICollidableObject;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatViewBuiltSignal extends Signal {
		
		public function CombatViewBuiltSignal() {
			super(Vector.<ICollidableObject>);
		}
		
	}

}