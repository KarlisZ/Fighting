package combat.view {
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatView extends Sprite {
		
		public function CombatView() {
			
		}
		
		public function addFighter(fighter:Fighter):void {
			addChild(fighter);
		}
		
	}

}