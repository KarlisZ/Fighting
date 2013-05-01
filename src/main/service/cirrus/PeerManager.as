package main.service.cirrus 
{
	import com.evolutiongaming.games.core.utils.log.EvoLogger;
	import com.evolutiongaming.games.core.utils.log.IEvoLogger;
	import com.junkbyte.console.Cc;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import main.service.cirrus.data.StreamType;
	import main.service.cirrus.data.SwarmCommandType;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PeerManager 
	{
		static private const ON_RECEIVE_DATA:String = 'onReceiveData';		
		
		private var logger:IEvoLogger = EvoLogger.getLogger(PeerManager);
		private var publicInStreams:Vector.<StreamVo> = new <StreamVo>[];
		private var publicOutStream:NetStream;
		private var privateInStreams:Vector.<StreamVo> = new <StreamVo>[];
		private var privateOutStreams:Vector.<StreamVo> = new <StreamVo>[];		
		private var peers:Vector.<Peer> = new <Peer>[];
		private var pingTime:Number;
		
		public var connection:NetConnection;
		
		public function PeerManager() 
		{
			
		}
		
		/**
		 * Connects to Cirrus p2p network.
		 * @param	peerId	Any peer ID from within the swarm
		 */
		public function connectToSeed(seedId:String):void
		{
			logger.debug('Connecting to seed with ID ' + seedId);
			createInStream(StreamType.LISTEN_PUBLIC, seedId);
		}

		public function createPrivateConnection(peerId:String):void
		{
			Cc.log('Creating private connection to ' + peerId);
			logger.debug('Creating private connection to ' + peerId);
			var privateHash:String = Math.random().toString(); // TODO: create actual unique hash
			createOutStream(StreamType.PUBLISH_PRIVATE, privateHash);
			sendToSwarm(SwarmCommandType.CREATE_PRIVATE_CONNECTION, [peerId, privateHash]);
		}
		
		private function createOutStream(type:String, uniqueId:String = null):String 
		{
			var streamName:String = 'publishStreamType' + type + '::' + connection.nearID;
			if (uniqueId)
				streamName = streamName.concat('::', uniqueId);
			
			var newStream:NetStream = new NetStream(connection, NetStream.DIRECT_CONNECTIONS);
			newStream.addEventListener(NetStatusEvent.NET_STATUS, onOutboundNetStatus);
			var client:Object = { };
			client.onNetStatus = onOutboundNetStatus;
			
			switch (type)
			{
				case StreamType.PUBLISH_PUBLIC:
					if (publicOutStream)
						throw new Error("A public out stream already exists!");
						
					client.onPeerConnect = onPublicPeerConnect;
					publicOutStream = newStream;
					break;
					
				case StreamType.PUBLISH_PRIVATE:
					client.onPeerConnect = onPrivatePeerConnect;
					privateOutStreams.push(new StreamVo(type, newStream, connection.nearID, uniqueId));
					break;
					
				default:
					throw new Error('Unexpected stream type: ' + type);
			}			
			
			newStream.client = client;
			newStream.publish(streamName);
			
			
			logger.debug('publishing to ', streamName);
			return streamName;
		}
		
		private function createInStream(type:String, peerId:String, uniqueId:String = null):void 
		{
			
			var newStream:NetStream = new NetStream(connection, peerId);
			newStream.addEventListener(NetStatusEvent.NET_STATUS, onInboundNetStatus);
			var client:Object = { };
			client.onReceiveData = onReceiveData;
			client.onNetStatus = onInboundNetStatus;
			newStream.client = client;
			
			var streamVo:StreamVo = new StreamVo(type, newStream, peerId, uniqueId);
			
			switch (type)
			{
				// the function param type defines what type to listen to, but seed publishes to publish id so we listen to that
				case StreamType.LISTEN_PUBLIC:
					publicInStreams.push(streamVo);
					type = StreamType.PUBLISH_PUBLIC; 
					break;
					
				case StreamType.LISTEN_PRIVATE:
					privateInStreams.push(streamVo);
					type = StreamType.PUBLISH_PRIVATE;
					break;
					
					
				default:
					throw new Error('Unexpected stream type: ' + type);
					
			}				
			
			var streamName:String = 'publishStreamType' + type + '::' + peerId;
			
			if (uniqueId)
				streamName = streamName.concat('::', uniqueId);
			
			newStream.play(streamName);
			
			logger.debug('listening on ', streamName);
		}
		
		
		private function onOutboundNetStatus(e:NetStatusEvent):void 
		{
			logger.debug("onOutboundNetStatus()", e.info.code); 
		}
		
		
		
		private function onInboundNetStatus(e:NetStatusEvent):void 
		{
			logger.debug("onInboundNetStatus()", e.info.code); 
			
		}
		
		private function onConnectionNetStatus(e:NetStatusEvent):void 
		{
			logger.debug("onConnectionNetStatus()", e.info.code); 
			
		}
		
		public function broadcast(data:Array, exceptId:String = null):void
		{
			sendToSwarm(SwarmCommandType.BROADCAST, data);
		}
		
		public function pingPeer(id:String):void 
		{
			sendToSwarm(SwarmCommandType.PING, [getTimer()]);
		}
		
		public function publishToPublic():void 
		{
			createOutStream(StreamType.PUBLISH_PUBLIC);
		}
		
		private function replyPing(time:String):void 
		{
			sendToSwarm(SwarmCommandType.REPLY_TO_PING, [time]);
		}
		
		/**
		 * General purpose communication method.
		 * @param	commandType
		 * @param	data
		 */
		private function sendToSwarm(commandType:String, data:Array):void
		{
			data.unshift(connection.nearID);
			data.unshift(commandType);
			data.unshift(ON_RECEIVE_DATA);			
			logger.debug('Sending data to swarm: ', String(data));
			publicOutStream.send.apply(null, data);
		}		
		
		private function sendToPeer(peerId:String):void
		{
			getOutStream(peerId).send(ON_RECEIVE_DATA, SwarmCommandType.CREATE_PRIVATE_CONNECTION, connection.nearID, peerId);
		}
		
		/**
		 * Returns a private out stream by id
		 * @param	id
		 * @return
		 */
		private function getOutStream(id:String):NetStream
		{
			for each (var o:StreamVo in privateOutStreams) 
			{
				if (o.peerId === id)
					return o.stream
			}
			return null;
		}
		
		/**
		 * Returns a public or private in stream by id // TODO: should get by type too
		 * @param	id
		 * @return
		 */
		private function getInStream(id:String):NetStream
		{
			var allInStreams:Vector.<StreamVo> = publicInStreams.concat(privateInStreams);
			for each (var o:StreamVo in publicInStreams) 
			{
				if (
						(o.type === StreamType.LISTEN_PUBLIC || o.type === StreamType.LISTEN_PRIVATE)
						&& o.peerId === id
					)
					return o.stream
			}
			return null;
		}
		
		private function onPrivatePeerConnect(stream:NetStream):void 
		{
			Cc.log("Private peer connected: " + stream.farID);
			logger.debug("onPrivatePeerConnect(), far id:", stream.farID);
			if(!getInStream(StreamType.LISTEN_PRIVATE, stream.farID)) // if you aren't the requester of the connection
				createInStream(StreamType.LISTEN_PRIVATE, stream.farID, )
		}		
		
		
		private function onPublicPeerConnect(stream:NetStream):void 
		{
			Cc.log("Public peer connected: " + stream.farID);
			logger.debug("onPublicPeerConnect(), far id:", stream.farID);
			
			if(!getInStream(stream.farID) && !getOutStream(stream.farID))
				addPeerToSwarm(stream.farID);
		}		
		
		private function addPeerToSwarm(peerId:String):void 
		{
			logger.debug('Adding new peer: ' + peerId);
			createInStream(StreamType.LISTEN_PUBLIC, peerId);
			
			if (publicInStreams.length >= 2) // only tell peers to add new peer if there is a third peer
			{
				Cc.log('Telling swarm to add peer: ' + peerId);
				sendToSwarm(SwarmCommandType.ADD_PEER, [peerId]);
			}
		}
		
		private function onReceiveData(...params):void
		{
			//var castHash:String = params.shift();
			var command:String = params.shift();
			var peerId:String = params.shift();
			
			logger.debug('onReceiveData() command=' + command, 'parameters: ', params, 'peer ID: ',peerId );
			
			switch(command)
			{
				case SwarmCommandType.BROADCAST:
					
					Cc.log('Received broadcast data: ' + params.toString());
					//broadcast(params, peerId);
					break;
					
				case SwarmCommandType.CREATE_PRIVATE_CONNECTION:
					var privatePublishId:String = params.shift();
					var uniqueId:String = params.shift();
					if (connection.nearID === privatePublishId)
					{
						Cc.log('Request for private connection received, setting up listening stream...');
						createOutStream(StreamType.PUBLISH_PRIVATE, uniqueId);
						createInStream(StreamType.LISTEN_PRIVATE, peerId, uniqueId);
					}
					else
						Cc.log('Request for private connection received, but not for me.');
					break;
					
				case SwarmCommandType.PING:
					Cc.log('Ping received from peer '+peerId+', replying...');
					replyPing(params[0]);
					break;
					
				case SwarmCommandType.REPLY_TO_PING:
					Cc.log('Your latency to peer ' + peerId + ' is ' + (getTimer() - Number(params[0])) + 'ms.');
					break;
					
				case SwarmCommandType.ADD_PEER:
					var otherPeerId:String = params.shift();
					// don't add as a new peer if alrady connected to that peer and if new peer is you
					if (!getInStream(otherPeerId) && otherPeerId != connection.nearID)
					{
						Cc.log('New peer in swarm: ' + otherPeerId);
						createInStream(StreamType.LISTEN_PUBLIC, otherPeerId); 
					}
					break;
			}
		}
		
		
		
	}

}
import flash.net.NetStream;

class Peer
{
	public var id:String;
	
	public function Peer(id:String)
	{
		this.id = id;
	}
}

class StreamVo
{
	public var uniqueId:String;
	public var type:String;
	public var stream:NetStream;
	public var peerId:String;
	// TODO: save far id for private connections so when returning on onPeerConnect original peer can listen on remote peers publish
	public function StreamVo(type:String, stream:NetStream, peerId:String, uniqueId:String = null) 
	{
		this.uniqueId = uniqueId;
		this.type = type;
		this.stream = stream;
		this.peerId = peerId;
		
	}
}