package combat.command {
	import combat.data.Control;
	import combat.data.ControlMap;
	import combat.model.CombatModel;
	import combat.signal.ControlInputSignal;
	import combat.view.api.IFighter;
	import flash.events.KeyboardEvent;
	import org.robotlegs.mvcs.SignalCommand;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class ManageCombatInputsCommand extends SignalCommand {
		
		[Inject] public var keyboardEvent:KeyboardEvent;
		
		[Inject] public var model:CombatModel;
		
		[Inject] public var controlInputSignal:ControlInputSignal;
		
		override public function execute():void {
			var control:Control;
			for each (var fighter:IFighter in model.fighters) {
				control = fighter.player.controlMap.getControl(keyboardEvent.keyCode, keyboardEvent.ctrlKey, keyboardEvent.altKey, keyboardEvent.shiftKey, keyboardEvent.ctrlKey);
				
				if (control) {
					controlInputSignal.dispatch(keyboardEvent, control, fighter);
					break;
				}
			}
		}
		
	}

}