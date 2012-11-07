package combat.engine.api {
	import combat.data.AffectVO;
	import combat.view.ICollidableObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public interface IEngine {
		
		function setup(tick:Number, gravity:Number):void;
		function addObjects(objects:Vector.<ICollidableObject>):void;
		function addStaticObjects(stage:ICollidableObject):void;
		
		function affectWorld(affectVO:AffectVO):void;
		
		function get stage():Stage;
		function get pixelsToMeters():Number;
		
		function set stage(stage:Stage):void;
		function set pixelsToMeters(value:Number):void;
	}

}