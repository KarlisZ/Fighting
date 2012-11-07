package combat.view.base {
	import combat.view.ICollidableObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CollidibleObject extends MovieClip implements ICollidableObject {

		public var type:String;
		public var vector:Point;
		
		public function CollidibleObject() {
			
		}
		
		public function getSubObjects():Vector.<MovieClip> {return Vector.<MovieClip>()}
		
	}

}