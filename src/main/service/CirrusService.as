package main.service 
{
	import com.evolutiongaming.games.core.utils.log.EvoLogger;
	import com.evolutiongaming.games.core.utils.log.IEvoLogger;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.System;
	import flash.utils.setTimeout;
	import main.model.MainModel;
	import main.service.cirrus.PeerManager;
	import main.service.events.CirrusServiceEvent;
	import org.robotlegs.mvcs.Actor;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CirrusService extends Actor
	{
		[Inject] public var model:MainModel; // TODO: remove this ofc
		
		// cirrus dev key 9bcd901b7ae990234c275219-b39f5f7ebb8c
		// connection token rtmfp://p2p.rtmfp.net/9bcd901b7ae990234c275219-b39f5f7ebb8c/
		private const CIRRUS_DEV_KEY:String = "9bcd901b7ae990234c275219-b39f5f7ebb8c";
		private const CIRRUS_URL:String = "rtmfp://p2p.rtmfp.net/";
		
		private var logger:IEvoLogger = EvoLogger.getLogger(CirrusService);
		private var netConnection:NetConnection;
		private var peerManager:PeerManager;
		private var seedId:String;
		
		public function CirrusService() 
		{
			peerManager = new PeerManager();
			netConnection = new NetConnection();
		}
		
		public function connectToNetwork(peerId:String):void 
		{
			seedId = peerId;
			connectToCirrus();
		}
		
		private function connectToCirrus():void 
		{
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			netConnection.connect(CIRRUS_URL, CIRRUS_DEV_KEY);
		}
		
		private function onConnectionNetStatus(e:NetStatusEvent):void 
		{
			peerManager.debugTf = model.debugTf;
			
			
			logger.debug('onConnectionNetStatus', e.info.code);
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					if (!seedId) System.setClipboard(netConnection.nearID);
					peerManager.connectToNetwork(netConnection, seedId);
					break;
			}
		}
		
		public function createNetwork():void
		{
			connectToCirrus();
		}
		
		public function send(data:*):void 
		{
			print("sending", data);
			peerManager.broadcast([data]);
		}
		
		private function print(...rest):void
		{
			logger.debug.apply(null, rest);
			model.debugTf.text += "\n" + rest;
		}
	}

}