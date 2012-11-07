package combat.view {
	import combat.constant.ActionType;
	import combat.constant.CollidingObjectType;
	import combat.data.AffectType;
	import combat.data.AffectVO;
	import combat.data.AnimationType;
	import combat.data.DirectionType;
	import combat.data.Player;
	import combat.signal.AffectSignal;
	import combat.view.api.IFighter;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class Fighter extends FighterAsset implements ICollidableObject, IFighter {
		private var subObjects:Vector.<MovieClip>;
		
		
		private var _player:Player;
		public var blocking:Boolean;
		
		private var _affectSignal:AffectSignal = new AffectSignal();
		private var currentDirection:String = DirectionType.RIGHT;
		private var delayedAffects:Vector.<uint>;
		
		public function Fighter(player:Player) {
			_player = player;
			init();
		}
		
		private function init():void
		{
			subObjects = new Vector.<MovieClip>();
			// populate subObjects
			var l:uint = animation.numChildren;
			for (var i:int = 0; i < l; i++)
			{
				subObjects.push(animation.getChildAt(i));
			}
			type = CollidingObjectType.DYNAMIC;
			vector = new Point();
		}
		
		public function doAction(type:String, id:String):void
		{
			var affectVO:AffectVO = new AffectVO(this);
			var delay:uint, animationType:String;
			switch(type + "_" + id)
			{
				case AffectType.MOVE_RIGHT:
					turn(DirectionType.RIGHT);
					animationType = AnimationType.MOVE_HORIZONTAL;
					break;
					
				case AffectType.MOVE_LEFT:
					animationType = AnimationType.MOVE_HORIZONTAL;
					turn(DirectionType.LEFT);
					break;
					
				case AffectType.MOVE_JUMP:
					animationType = AnimationType.MOVE_JUMP;
					//delay = ;
					break;
					
				case AffectType.ATTACK_HIGH:
					animationType = AnimationType.ATTACK_HIGH;
					//delay = ;
					break;
					
				default:
					trace("[FIGHTER] WARNING: doAction() encountered unexpected action type " + type + " with id " + id);
					return;
			}
			
			affectVO.setByType(type + "_" + id);
			
			if (delay)
				delayAffect(affectVO, delay);
			else
				_affectSignal.dispatch(affectVO);
			
			if (animationType)
				animation.gotoAndPlay(animationType);
		}
		
		public function stopAction(type:String, id:String):void
		{
			animation.gotoAndPlay(AnimationType.IDLE);
			switch(type + "_" + id)
			{
				case AffectType.MOVE_RIGHT:
				case AffectType.MOVE_LEFT:
					var affectVO:AffectVO = new AffectVO(this);
					affectVO.setByType(type + "_" + id + AffectType.TYPE_SUFFIX_STOP);
					_affectSignal.dispatch(affectVO);
					break;
					
				case AffectType.MOVE_JUMP:
					break;
					
				case AffectType.ATTACK_HIGH:
					break;
					
				default:
					trace("[FIGHTER] WARNING: stopAction() encountered unexpected action type " + type + " with id " + id);
					return;
			}
		}
		
		private function delayAffect(affectVO:AffectVO, delay:uint):void
		{
			delayedAffects.push(setTimeout(dispatchDelayedAffect, delay, affectVO));
		}
		
		private function dispatchDelayedAffect(affectVO:AffectVO):void
		{
			delayedAffects.shift();
			_affectSignal.dispatch(affectVO);
		}
		
		private function turn(direction:String):void
		{
			if (currentDirection === direction) return;
			currentDirection = direction;
			
			switch (direction)
			{
				case DirectionType.RIGHT:
				case DirectionType.LEFT:
					animation.scaleX *= -1;
					break;
			}
		}
		
		/* INTERFACE combat.view.ICollidableObject */
		
		override public function getSubObjects():Vector.<MovieClip> {
			return subObjects;
		}
		
		public function get affectSignal():AffectSignal
		{
			return _affectSignal;
		}
		
		public function get player():Player
		{
			return _player;
		}
		
	}

}