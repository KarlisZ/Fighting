package main.service 
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.System;
	import flash.utils.setTimeout;
	import main.model.MainModel;
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
		
		private var netConnection:NetConnection;
		private var sendStream:NetStream;
		private var receiveStream:NetStream;
		private var seed:String;
		private var inited:Boolean;
		private var inbound:Boolean;
		
		public function CirrusService() 
		{
			netConnection = new NetConnection();
		}
		
		private function onConnectionNetStatus(e:NetStatusEvent):void 
		{
			print("connection status", e.info.code, inited);
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					if (!inited) 
					{
						inited = true;
						initStreams();
					}
					break;				
			}
		}
		
		private function initStreams():void 
		{
			// TODO: remove me
			if (!seed)			
				System.setClipboard(netConnection.nearID);			
			else
				createInboundStream(seed);
				
			createOutboundStream();
		}
		
		private function createOutboundStream():void 
		{
			print("create outbound");
			sendStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, onOutboundNetStatus);
			var client:Object = { };
			client.onPeerConnect = onPeerConnect;
			client.onNetStatus = onOutboundNetStatus;
			sendStream.client = client;
			if(!seed) sendStream.publish('seedPublish');
			
			
			print("near id", netConnection.nearID);
			//receiveStream = new NetStream(
		}
		
		private function onInboundNetStatus(e:NetStatusEvent):void 
		{
			print("inbound net stream event", e.info.code);
		}
		
		private function onPeerConnect(stream:NetStream):void 
		{
			print("peer connect, far id:", stream.farID);
			if (!seed)
				setTimeout(send, 2000, "publishTo", "peerPublish");
				
			createInboundStream(stream.farID);
			delete sendStream.client.onPeerConnect;
		}
		
		private function onOutboundNetStatus(e:NetStatusEvent):void 
		{
			print("outbound net stream event", e.info.code);
			switch(e.info.code)
			{
				case "NetStream.Publish.Start":
					dispatch(new CirrusServiceEvent(CirrusServiceEvent.CONNECTED));
					
					break;
					
				
			}
		}
		
		private function createInboundStream(farId:String):void 
		{
			print("trying inbound, seed:", farId);
			inbound = true;
			receiveStream = new NetStream(netConnection, farId);
			receiveStream.addEventListener(NetStatusEvent.NET_STATUS, onInboundNetStatus);
			var client:Object = { };
			client = { };
			client.onNetStatus = onInboundNetStatus;
			client.onReceiveData = onReceiveData;
			receiveStream.client = client;
			if (!seed)
				receiveStream.play('peerPublish');
			else
				receiveStream.play('seedPublish');
		}
		
		public function connect(token:String = null):void
		{
			this.seed = token;
				
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			netConnection.connect(CIRRUS_URL, CIRRUS_DEV_KEY);
		}
		
		public function send(...params):void
		{
			print("sending", params);
			params.unshift("onReceiveData");
			sendStream.send.apply(null, params);
		}
		
		private function onReceiveData(...params):void
		{
			print("holy fuck", params);
			switch(params[0])
			{
				case "publishTo":
					sendStream.publish(params[1]);
					break;
			}
		}
		
		private function print(...rest):void
		{
			trace.apply(null, rest);
			model.debugTf.text += "\n" + rest;
		}
	}

}