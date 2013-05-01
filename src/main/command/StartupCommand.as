package main.command {
	import common.event.SubcontextEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
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
		}
	}

}