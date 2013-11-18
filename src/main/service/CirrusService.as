package main.service 
{
	import com.junkbyte.console.Cc;
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import common.event.SubcontextEvent;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.System;
	import flash.utils.setTimeout;
	import common.factory.SubcontextEventFactory;
	import main.service.cirrus.events.PeerManagerEvent;
	import main.service.cirrus.PeerManager;
	import main.service.events.CirrusServiceEvent;
	import org.robotlegs.mvcs.Actor;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class CirrusService extends Actor
	{
		
		// cirrus dev key 9bcd901b7ae990234c275219-b39f5f7ebb8c
		// connection token rtmfp://p2p.rtmfp.net/9bcd901b7ae990234c275219-b39f5f7ebb8c/
		private const CIRRUS_DEV_KEY:String = "9bcd901b7ae990234c275219-b39f5f7ebb8c";
		private const CIRRUS_URL:String = "rtmfp://p2p.rtmfp.net/";
		
		private var logger:ILogger = Logger.getLogger(CirrusService);
		private var netConnection:NetConnection;
		private var peerManager:PeerManager;
		private var seedId:String;
		
		public function CirrusService() 
		{
			peerManager = new PeerManager();
			netConnection = new NetConnection();
			
			listenToPeerManager();
		}
		
		private function listenToPeerManager():void 
		{
			peerManager.addEventListener(PeerManagerEvent.PUBLIC_PEER_CONNECTED, onPeerManagerEvent);
			peerManager.addEventListener(PeerManagerEvent.BROADCAST_RECEIVED, onPeerManagerEvent);
		}
		
		private function onPeerManagerEvent(e:PeerManagerEvent):void 
		{
			switch(e.type)
			{
				case PeerManagerEvent.PUBLIC_PEER_CONNECTED:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.PUBLIC_PEER_CONNECTED, e.data));
					break;
					
				case PeerManagerEvent.BROADCAST_RECEIVED:
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.BROADCAST_RECEIVED, e.data));
					
				default:;
			}
		}
		
		public function connectToNetwork(peerId:String):void 
		{
			peerManager.connectToSeed(peerId);
		}
		
		private function connectToCirrus():void 
		{
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			netConnection.connect(CIRRUS_URL, CIRRUS_DEV_KEY);
		}
		
		private function onConnectionNetStatus(e:NetStatusEvent):void 
		{
			logger.log('onConnectionNetStatus', e.info.code);
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					Cc.log('Connection successful! Your peer ID is: ' + netConnection.nearID);
					peerManager.connection = netConnection;
					peerManager.publishToPublic();
					
					dispatch(new CirrusServiceEvent(CirrusServiceEvent.CONNECTED_TO_CIRRUS));
					dispatch(SubcontextEventFactory.produceEvent(SubcontextEvent.NEAR_ID_KNOWN, netConnection.nearID));
					break;
			}
		}
		
		public function createNetwork():void
		{
			connectToCirrus();
		}
		
		public function broadcast(data:*):void 
		{
			logger.log("sending", data);
			peerManager.broadcast([data]);
		}
		
		public function pingPeer(nearId:String):void 
		{
			peerManager.pingPeer(nearId);
		}
		
		public function createPrivateConnection(nearId:String):void 
		{
			peerManager.createPrivateConnection(nearId);
		}
		
		public function sendToPrivateSwarm(nearId:String, message:String):void 
		{
			peerManager.sendToPeer(nearId, [message]);
		}
	}

}