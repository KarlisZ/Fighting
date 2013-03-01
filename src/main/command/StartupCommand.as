package main.command {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import main.event.TestEvent;
	import main.model.MainModel;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.SignalCommand;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class StartupCommand extends Command
	{
		[Inject] public var model:MainModel;
		
		override public function execute():void
		{
			var tf:TextField = new TextField();
			tf.background 	=
			tf.opaqueBackground = true
			tf.width	=
			tf.height	= 500
			contextView.addChild(tf);
			
			model.debugTf = tf;
			
			tf = new TextField();
			tf.background 	=
			tf.opaqueBackground = true
			tf.width	= 500;
			tf.height	= 100;
			tf.x = 500;
			tf.type = TextFieldType.INPUT;
			model.inputTf = tf;
			contextView.addChild(tf);
			
			contextView.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private var inited:Boolean = false;
		private function onKeyUp(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
					if (!inited)
					{
						model.cirrusToken = model.inputTf.text;
						dispatch(new TestEvent(TestEvent.CONNECT_TO_NETWORK));
						inited = true;
					}
					else
					{
						dispatch(new TestEvent(TestEvent.SEND_DATA, model.inputTf.text));
					}
					break;
					
				case Keyboard.ESCAPE:
					dispatch(new TestEvent(TestEvent.CREATE_NETWORK));
					inited = true;
					break;
					
			}
		}
		
	}

}