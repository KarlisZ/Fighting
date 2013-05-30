package combat.context {
	import combat.command.BuildCombatViewCommand;
	import combat.command.LoadDataCommand;
	import combat.command.ManageCombatInputsCommand;
	import combat.engine.api.IEngine;
	import combat.engine.Box2DEngine;
	import combat.engine.Engine;
	import combat.engine.EngineMediator;
	import combat.mediator.CombatViewMediator;
	import combat.mediator.FighterMediator;
	import combat.model.CombatModel;
	import combat.signal.AffectSignal;
	import combat.signal.BuildCombatViewSignal;
	import combat.signal.CombatViewBuiltSignal;
	import combat.signal.ControlInputSignal;
	import combat.signal.DataLoadedSignal;
	import combat.signal.EngineReadySignal;
	import combat.signal.KeyboardChangeSignal;
	import combat.view.api.IFighter;
	import combat.view.CombatView;
	import combat.view.Fighter;
	import flash.display.DisplayObjectContainer;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalContext;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatContext extends SignalContext {
		
		public function CombatContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void 
		{
			//var startupSignal:Signal = new Signal();
			//signalCommandMap.mapSignal(startupSignal, StartupCommand, true);
			
			injector.mapSingleton(CombatModel);
			
			injector.mapSingleton(EngineReadySignal);
			injector.mapSingleton(ControlInputSignal);
			injector.mapSingleton(CombatViewBuiltSignal);
			injector.mapSingleton(AffectSignal);
			
			var initSignal:Signal = new Signal();
			signalCommandMap.mapSignal(initSignal, LoadDataCommand, true);
			signalCommandMap.mapSignalClass(DataLoadedSignal, BuildCombatViewCommand, true);
			
			signalCommandMap.mapSignalClass(KeyboardChangeSignal, ManageCombatInputsCommand);
			
			mediatorMap.mapView(CombatView, CombatViewMediator);
			mediatorMap.mapView(Box2DEngine, EngineMediator, IEngine, false);
			mediatorMap.mapView(Fighter, FighterMediator, IFighter);
			
			mediatorMap.createMediator(new Box2DEngine());
			
			//initSignal.dispatch();
			//super.startup();
		}
		
	}

}