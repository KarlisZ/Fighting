package combat.command {
	import combat.data.AssetType;
	import combat.model.CombatModel;
	import combat.signal.DataLoadedSignal;
	import flash.utils.Dictionary;
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.robotlegs.mvcs.SignalCommand;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class LoadDataCommand extends SignalCommand {
		private var loader:IAssetLoader;
		
		[Inject] public var model:CombatModel;
		
		[Inject] public var completeSignal:DataLoadedSignal;
		
		override public function execute():void {
			if (!model.loader) model.loader = new AssetLoader("CombatLoader");
			loader = model.loader;
			
			var loadArray:Array =	[
										{id:AssetType.STAGE_DATA, url:model.STAGE_DATA_PATH},
										{id:AssetType.CONTROL_MAPS, url:model.CONTROL_MAP_PATH}
									];
			for each (var item:Object in loadArray) {
				loader.addLazy(item.id, item.url);
			}
			
			loader.onComplete.addOnce(handleDataLoaded);
			loader.onChildError.add(handleLoadError);
			
			loader.start();
		}
		
		private function handleLoadError(e:ErrorSignal, loader:ILoader ):void {
			trace("#LoadDataCommand: " + e.message);
		}
		
		private function handleDataLoaded(signal:LoaderSignal, data:Dictionary):void {
			model.stageDataXML = XML(data[AssetType.STAGE_DATA]);
			model.controlMapXML = XML(data[AssetType.CONTROL_MAPS]);
			
			// TODO: for testing
			model.test();
			
			completeSignal.dispatch();
		}
		
	}

}