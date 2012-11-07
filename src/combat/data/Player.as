package combat.data {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Player {
		
		public var type:String;
		public var startingPosition:Point;
		public var controlMap:ControlMap;
		
		public function Player(type:String, startingPosition:Point, controlMap:ControlMap) {
			this.type = type;
			this.startingPosition = startingPosition;
			this.controlMap = controlMap;
		}
		
	}

}