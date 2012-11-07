package combat.engine {
	import combat.data.AffectVO;
	import combat.engine.api.IEngine;
	import combat.model.CombatModel;
	import combat.signal.AffectSignal;
	import combat.signal.CombatViewBuiltSignal;
	import combat.view.ICollidableObject;
	import org.robotlegs.mvcs.SignalMediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class EngineMediator extends SignalMediator {
		
		[Inject] public var initSignal:CombatViewBuiltSignal;
		[Inject] public var affectSignal:AffectSignal;
		[Inject] public var model:CombatModel;
		[Inject] public var engine:IEngine;
		
		public function EngineMediator() {
			
		}
		
		override public function onRegister():void {
			initSignal.addOnce(initSignalHandler);
			affectSignal.add(onAffect);
			engine.stage = contextView.stage;
		}
		
		private function onAffect(affectVO:AffectVO):void
		{
			engine.affectWorld(affectVO);
		}
		
		private function initSignalHandler(objects:Vector.<ICollidableObject>):void {
			initEngine(objects);
		}
		
		private function initEngine(objects:Vector.<ICollidableObject>):void {
			engine.pixelsToMeters = model.PIXELS_TO_METERS;
			engine.setup(model.DEFAULT_ENGINE_TICK, model.DEFAULT_ENGINE_GRAVITY);
			engine.addStaticObjects(objects.shift());
			engine.addObjects(objects);
			
		}
		
	}

}