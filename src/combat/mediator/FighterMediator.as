package combat.mediator {
	import combat.data.AffectVO;
	import combat.signal.AffectSignal;
	import combat.view.api.IFighter;
	import org.robotlegs.mvcs.SignalMediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class FighterMediator extends SignalMediator {
		
		[Inject] public var fighter:IFighter;
		[Inject] public var affectSignal:AffectSignal;
		
		public function FighterMediator() {
			
		}
		
		override public function onRegister():void {
			fighter.affectSignal.add(onAffect);
			
		}
		
		private function onAffect(affectVO:AffectVO):void
		{
			affectSignal.dispatch(affectVO);
		}
		
	}

}