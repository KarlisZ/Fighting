package combat.view {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public interface ICollidableObject {
		
		function getSubObjects():Vector.<MovieClip>;
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get height():Number;
	}

}