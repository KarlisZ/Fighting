package combat.view {
	import combat.constant.CollidingObjectType;
	import combat.view.base.CollidibleObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatStage extends CollidibleObject {
		
		private static const ALL_STAGES:Array = [
													{ key:"CombatStage", assetClass:CombatStageAsset }
												];
		
		public var asset:MovieClip;
		
		public function CombatStage(assetName:String) {
			init(assetName);
		}
		
		private function init(assetName:String):void {
			var filterCallback:Function = function(item:Object, ...ignore):Boolean { return item.key == assetName };
			var assetClass:Class = ALL_STAGES.filter(filterCallback)[0].assetClass;
			asset = new assetClass();
			addChild(asset);
			
			type = CollidingObjectType.STATIC;
		}
		
		/* INTERFACE combat.view.ICollidableObject */
		
		override public function getSubObjects():Vector.<MovieClip> {
			var ret:Vector.<MovieClip> = new Vector.<MovieClip>();
			for (var i:int = 0; i < asset.numChildren; i++)
			{
				ret.push(asset.getChildAt(i));
			}
			//ret.push(asset);
			return ret;
		}
		
	}

}