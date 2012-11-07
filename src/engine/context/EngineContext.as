package engine.context {
	import engine.model.EngineModel;
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.SignalContext;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class EngineContext extends SignalContext {
		
		public function EngineContext(injector:IInjector) {
			injector = injector;
			super();
		}
		
		override public function startup():void {
			
			injector.mapSingleton(EngineModel);
			
			var initSignal:Signal = new Signal();
			//signalCommandMap.mapSignal(initSignal, LoadDataCommand, true);
			
			initSignal.dispatch();
			super.startup();
		}
		
	}

}