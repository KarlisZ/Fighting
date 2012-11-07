package combat.model {
	import combat.data.ControlMap;
	import combat.data.Player;
	import combat.view.api.IFighter;
	import combat.view.CombatStage;
	import constant.PlayerType;
	import flash.geom.Point;
	import org.assetloader.core.IAssetLoader;
	import org.robotlegs.mvcs.Actor;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CombatModel extends Actor{
		public const STAGE_DATA_PATH:String = "data/stage_data.xml";
		public const CONTROL_MAP_PATH:String = "data/control_maps.xml";
		
		// engine constants
		public const DEFAULT_ENGINE_TICK:Number = 1/60;
		public const DEFAULT_ENGINE_GRAVITY:Number = 30;
		public const PIXELS_TO_METERS:Number = 200;
		
		public var combatStage:CombatStage;
		public var fighters:Vector.<IFighter> = new Vector.<IFighter>();
		public var players:Vector.<Player> = new Vector.<Player>();
		public var controlMaps:Vector.<ControlMap> = new Vector.<ControlMap>();
		public var stageDataXML:XML;
		public var controlMapXML:XML;
		
		public var loader:IAssetLoader;
		
		public function CombatModel() {
			//test();
		}
		
		public function test():void {
			trace("setting up test combat");
			controlMaps.push(
								new ControlMap(controlMapXML.map[0]),
								new ControlMap(controlMapXML.map[1])
							);
							
			var firstPosition:Point = new Point(Number(stageDataXML.stage.(@title == "test").startingPosition[0].@x),
												Number(stageDataXML.stage.(@title == "test").startingPosition[0].@y));
												
			var secondPosition:Point = new Point(Number(stageDataXML.stage.(@title == "test").startingPosition[1].@x),
												Number(stageDataXML.stage.(@title == "test").startingPosition[1].@y));
												
												
			players.push(	new Player(PlayerType.LOCAL, firstPosition, controlMaps[0]),
							new Player(PlayerType.AI, secondPosition, controlMaps[1]));
							
			combatStage = new CombatStage(stageDataXML.stage.(@title == "test").@static);
		}
		
	}

}