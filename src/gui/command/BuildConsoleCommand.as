package gui.command 
{
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.Console;
	import gui.mediator.ConsoleMediator;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class BuildConsoleCommand extends Command
	{
		
		override public function execute():void
		{
			Cc.config.commandLineAllowed = true;
			Cc.config.commandLineAutoCompleteEnabled = true;
			Cc.startOnStage(contextView, "`");
			Cc.commandLine = true;
			Cc.width = contextView.stage.stageWidth;
			Cc.height = 200
			
			mediatorMap.createMediator(Cc.instance);
		}
		
		
	}

}