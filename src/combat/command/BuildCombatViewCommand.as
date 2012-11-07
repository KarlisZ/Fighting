package combat.command {
	import combat.data.Player;
	import combat.model.CombatModel;
	import combat.signal.CombatViewBuiltSignal;
	import combat.view.api.IFighter;
	import combat.view.CombatStage;
	import combat.view.CombatView;
	import combat.view.Fighter;
	import combat.view.ICollidableObject;
	import flash.display.MovieClip;
	import org.robotlegs.mvcs.SignalCommand;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class BuildCombatViewCommand extends SignalCommand
	{
		
		//[Inject] public var type:String;
		[Inject] public var model:CombatModel;
		
		[Inject] public var completeSignal:CombatViewBuiltSignal;
		
		override public function execute():void {
			//TODO: use random seed for world generation
			var assets:Vector.<ICollidableObject> = new Vector.<ICollidableObject>();
			
			var combatView:CombatView = new CombatView();
			contextView.addChild(combatView);
			
			var combatStage:CombatStage = model.combatStage;
			combatView.addChild(combatStage);
			assets.push(combatStage);
			
			var fighter:Fighter = new Fighter(model.players[0]);
			model.fighters.push(fighter)
			combatView.addFighter(fighter);
			assets.push(fighter);
			
			fighter = new Fighter(model.players[1]);
			model.fighters.push(fighter)
			combatView.addFighter(fighter);
			assets.push(fighter);
			
			placeFighters();
			
			completeSignal.dispatch(assets);
		}
		
		private function placeFighters():void {
			
			for each (var fighter:IFighter in model.fighters) {
				var player:Player = fighter.player;
				
				fighter.x = player.startingPosition.x;
				fighter.y = player.startingPosition.y;
			}
			
		}
		
	}

}