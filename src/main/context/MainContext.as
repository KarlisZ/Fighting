package main.context {
	import combat.command.BuildCombatViewCommand;
	import combat.context.CombatContext;
	import engine.context.EngineContext;
	import flash.display.DisplayObjectContainer;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Context;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class MainContext extends Context {
		private var combatContext:CombatContext;
		
		public function MainContext(contextView:DisplayObjectContainer) {
			super(contextView);
		}
		
		override public function startup():void {
			combatContext = new CombatContext(contextView);
			
			super.startup();
		}
		
	}

}