package combat.data
{
	import combat.view.ICollidableObject;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class AffectVO
	{
		
		public var object:ICollidableObject;
		public var force:Point;
		public var persistentForce:Point;
		
		public function AffectVO(object:ICollidableObject = null)
		{
			this.object = object;
			
		}
		
		public function setByType(type:String):Boolean
		{
			var ret:Boolean = true;
			switch (type)
			{
				case AffectType.MOVE_JUMP:
					force = new Point(0, -300);
					break;
				
				case AffectType.MOVE_LEFT_STOP:
				case AffectType.MOVE_RIGHT:
					persistentForce = new Point(10, 0);
					break;
					
				case AffectType.MOVE_RIGHT_STOP:
				case AffectType.MOVE_LEFT:
					persistentForce = new Point(-10, 0);
					break;
					
				default:
					ret = false;
			}
			
			return ret;
		}
	}

}