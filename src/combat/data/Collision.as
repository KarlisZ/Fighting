package combat.data {
	import combat.view.base.CollidibleObject;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Collision {
		
		public static const AXIS_HORIZONTAL:String = "horizontal";
		public static const AXIS_VERTICAL:String = "vertical";
		
		public var subItemB:MovieClip;
		public var subItemA:MovieClip;
		public var itemB:CollidibleObject;
		public var itemA:CollidibleObject;
		public var obstructionAxis:String;
		
		public function Collision(itemA:CollidibleObject, itemB:CollidibleObject, subItemA:MovieClip, subItemB:MovieClip, axis:String) {
			this.subItemB = subItemB;
			this.subItemA = subItemA;
			this.itemB = itemB;
			this.itemA = itemA;
			this.obstructionAxis = axis;
		}
		
	}

}