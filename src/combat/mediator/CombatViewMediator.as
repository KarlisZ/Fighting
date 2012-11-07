package combat.mediator {
	import combat.data.Control;
	import combat.model.CombatModel;
	import combat.signal.ControlInputSignal;
	import combat.signal.KeyboardChangeSignal;
	import combat.view.api.IFighter;
	import combat.view.Fighter;
	import flash.events.KeyboardEvent;
	import org.osflash.signals.natives.NativeSignal;
	import org.robotlegs.mvcs.SignalMediator;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatViewMediator extends SignalMediator
	{
		private var keyDownSignal:NativeSignal;
		private var keyUpSignal:NativeSignal;
		private var downKeys:Vector.<uint> = new Vector.<uint>();
		
		[Inject] public var controlInputSignal:ControlInputSignal;
		[Inject] public var keyboardChangeSignal:KeyboardChangeSignal;
		[Inject] public var model:CombatModel;
		
		public function CombatViewMediator()
		{
			
		}
		
		override public function onRegister():void
		{
			signalMap.addToSignal(controlInputSignal, handleInput);
			
			keyDownSignal = new NativeSignal(contextView.stage, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			keyUpSignal = new NativeSignal(contextView.stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			keyUpSignal.add(handleKeyChange);
			keyDownSignal.add(handleKeyChange);
			
		}
		
		private function handleKeyChange(e:KeyboardEvent):void
		{
			keyboardChangeSignal.dispatch(e);
		}
		
		private function handleInput(event:KeyboardEvent, control:Control, fighter:IFighter):void
		{
			switch(event.type)
			{
				case KeyboardEvent.KEY_DOWN:
					if (!isKeyDown(event.keyCode)) {
						downKeys.push(event.keyCode);
						fighter.doAction(control.type, control.id);
					}
					break;
					
				case KeyboardEvent.KEY_UP:
					downKeys.splice(downKeys.indexOf(event.keyCode), 1);
					fighter.stopAction(control.type, control.id);
					break;
			}
		}
		
		private function isKeyDown(keyCode:uint):Boolean
		{
			return downKeys.indexOf(keyCode) >= 0 ? true : false;
		}
		
	}

}