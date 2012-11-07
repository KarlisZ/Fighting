package combat.view.api
{
	import combat.data.Player;
	import combat.signal.AffectSignal;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public interface IFighter
	{
		
		function get affectSignal():AffectSignal;
		function get player():Player;
		function get x():Number;
		function get y():Number;
		
		function set x(value:Number):void;
		function set y(value:Number):void;
		
		function doAction(type:String, id:String):void;
		
		function stopAction(type:String, id:String):void;
		
	}

}