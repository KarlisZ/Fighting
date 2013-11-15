package combat.context {
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
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
	import common.event.SubcontextEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalContext;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatContext extends SignalContext
	{
		private var mainDispatcher:IEventDispatcher;
		private var logger:ILogger = Logger.getLogger(CombatContext);
		
		public function CombatContext(contextView:DisplayObjectContainer, mainDispatcher:IEventDispatcher)
		{
			this.mainDispatcher = mainDispatcher;
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
			//signalCommandMap.mapSignal(initSignal, LoadDataCommand, true);
			signalCommandMap.mapSignalClass(DataLoadedSignal, BuildCombatViewCommand, true);
			
			signalCommandMap.mapSignalClass(KeyboardChangeSignal, ManageCombatInputsCommand);
			
			commandMap.mapEvent(SubcontextEvent.CREATE_TEST_COMBAT_STAGE, LoadDataCommand);
			
			mediatorMap.mapView(CombatView, CombatViewMediator);
			mediatorMap.mapView(Box2DEngine, EngineMediator, IEngine, false);
			mediatorMap.mapView(Fighter, FighterMediator, IFighter);
			
			mediatorMap.createMediator(new Box2DEngine());
			
			listenToMainContext();
			
			initSignal.dispatch();
			super.startup();
		}
		
		private function listenToMainContext():void 
		{
			mainDispatcher.addEventListener(SubcontextEvent.CREATE_TEST_COMBAT_STAGE, onSubcontextEvent);
		}
		
		private function onSubcontextEvent(e:SubcontextEvent):void 
		{
			dispatchEvent(new SubcontextEvent(e.type, e.data));			
		}
		
	}

}