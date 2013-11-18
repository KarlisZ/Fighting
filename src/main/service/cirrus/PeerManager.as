package main.service.cirrus 
{
	import com.junkbyte.console.Cc;
	import com.sigfa.logger.api.ILogger;
	import com.sigfa.logger.Logger;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import main.service.cirrus.data.StreamType;
	import main.service.cirrus.data.SwarmCommandType;
	import main.service.cirrus.events.PeerManagerEvent;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PeerManager extends EventDispatcher
	{
		static private const ON_RECEIVE_DATA:String = 'onReceiveData';		
		static private const PUBLISH_STREAM_TYPE:String = 'publishStreamType';		
		
		private var logger:ILogger = Logger.getLogger(PeerManager);
		private var publicInStreams:Vector.<StreamVo> = new <StreamVo>[];
		private var publicOutStream:NetStream;
		private var privateInStreams:Vector.<StreamVo> = new <StreamVo>[];
		private var privateOutStreams:Vector.<StreamVo> = new <StreamVo>[];		
		private var peers:Vector.<Peer> = new <Peer>[];
		private var pingTime:Number;
		
		public var connection:NetConnection;
		
		public function PeerManager() 
		{
			super(this);
		}
		
		/**
		 * Connects to Cirrus p2p network.
		 * @param	peerId	Any peer ID from within the swarm
		 */
		public function connectToSeed(seedId:String):void
		{
			logger.log('Connecting to seed with ID ' + seedId);
			createInStream(StreamType.LISTEN_PUBLIC, seedId);
		}

		public function createPrivateConnection(peerId:String):void
		{
			Cc.log('Creating private connection to ' + peerId);
			logger.log('Creating private connection to ' + peerId);
			createOutStream(StreamType.PUBLISH_PRIVATE, peerId);
			sendToSwarm(SwarmCommandType.CREATE_PRIVATE_CONNECTION, [peerId]);
		}
		
		/**
		 * Creates a publish stream
		 * @param	type	A StreamType string.
		 * @param	peerId	For private connections, the remote peer ID.
		 * @return	Returns the publishing stream name.
		 * @example	
		 * @example	
		 */
		private function createOutStream(type:String, remoteId:String = null):String 
		{
			var streamName:String = PUBLISH_STREAM_TYPE + type + '::' + connection.nearID;
			
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
					streamName = streamName.concat('::', remoteId);
					client.onPeerConnect = onPrivatePeerConnect;
					privateOutStreams.push(new StreamVo(type, newStream, remoteId));
					break;
					
				default:
					throw new Error('Unexpected stream type: ' + type);
			}			
			
			newStream.client = client;
			newStream.publish(streamName);
			
			
			logger.log('publishing to ', streamName);
			return streamName;
		}
		
		/**
		 * Creates a play stream.
		 * @param	type	A StreamType string.
		 * @param	peerId	The publishing peer ID.
		 * @example
		 * @example
		 */
		private function createInStream(type:String, peerId:String):void 
		{
			var streamName:String;
			
			var newStream:NetStream = new NetStream(connection, peerId);
			newStream.addEventListener(NetStatusEvent.NET_STATUS, onInboundNetStatus);
			var client:Object = { };
			client.onReceiveData = onReceiveData;
			client.onNetStatus = onInboundNetStatus;
			newStream.client = client;
			
			var streamVo:StreamVo = new StreamVo(type, newStream, peerId);
			
			switch (type)
			{
				case StreamType.LISTEN_PUBLIC:
					publicInStreams.push(streamVo);
					streamName = PUBLISH_STREAM_TYPE + StreamType.PUBLISH_PUBLIC + '::' + peerId;
					break;
					
				case StreamType.LISTEN_PRIVATE:
					privateInStreams.push(streamVo);
					streamName = PUBLISH_STREAM_TYPE + StreamType.PUBLISH_PRIVATE + '::' + peerId + '::' + connection.nearID;
					break;
					
					
				default:
					throw new Error('Unexpected stream type: ' + type);
					
			}		
			
			
			newStream.play(streamName);
			
			logger.log('listening on ', streamName);
		}
		
		
		private function onOutboundNetStatus(e:NetStatusEvent):void 
		{
			logger.log("onOutboundNetStatus()", e.info.code); 
		}
		
		
		
		private function onInboundNetStatus(e:NetStatusEvent):void 
		{
			logger.log("onInboundNetStatus()", e.info.code); 
			
		}
		
		private function onConnectionNetStatus(e:NetStatusEvent):void 
		{
			logger.log("onConnectionNetStatus()", e.info.code); 
			
		}
		
		public function broadcast(data:Array):void
		{
			sendToSwarm(SwarmCommandType.PARSE_BROADCAST, data);
		}
		
		public function pingPeer(id:String):void 
		{
			sendToSwarm(SwarmCommandType.REPLY_TO_PING, [getTimer()]);
		}
		
		public function publishToPublic():void 
		{
			createOutStream(StreamType.PUBLISH_PUBLIC);
		}
		
		private function replyPing(time:String):void 
		{
			sendToSwarm(SwarmCommandType.PARSE_PING_REPLY, [time]);
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
			logger.log('Sending data to swarm: ', String(data));
			publicOutStream.send.apply(null, data);
		}		
		
		public function sendToPeer(peerId:String, data:Array):void
		{
			data.unshift(connection.nearID);
			data.unshift(SwarmCommandType.PARSE_PRIVATE_DATA);
			data.unshift(ON_RECEIVE_DATA);			
			logger.log('Sending data to private peer: ', String(data));
			getOutStream(peerId).send.apply(null, data);
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
		private function getInStream(type:String, id:String):NetStream
		{
			var allInStreams:Vector.<StreamVo> = publicInStreams.concat(privateInStreams);
			for each (var o:StreamVo in allInStreams)
			{
				if (o.type === type	&& o.peerId === id)
					return o.stream
			}
			return null;
		}
		
		private function onPrivatePeerConnect(stream:NetStream):void 
		{
			// we will have a publish stream to the other peer before he connects to our publish
			// so if we don't have a publish stream to the farId, it's a third peer via a custom client.
			if (!getOutStream(stream.farID))
			{
				Cc.log('A third peer ' + stream.farID + ' is listening to a private publish stream!');
				logger.log('A third peer ' + stream.farID + ' is listening to a private publish stream!');
				// TODO: drop this connection and somehow create a new unique private connection with
				// a different name without publishing to this stream so the third party can't listen in.
				return;
			}
			
			Cc.log("Private peer connected: " + stream.farID);
			logger.log("onPrivatePeerConnect(), far id:", stream.farID);
			if(!getInStream(StreamType.LISTEN_PRIVATE, stream.farID)) // if you aren't the requester of the connection
				createInStream(StreamType.LISTEN_PRIVATE, stream.farID);
		}		
		
		
		private function onPublicPeerConnect(stream:NetStream):void 
		{
			Cc.log("Public peer connected: " + stream.farID);
			logger.log("onPublicPeerConnect(), far id:", stream.farID);
			
			// if don't have out stream to peer
			if(!getInStream(StreamType.LISTEN_PUBLIC, stream.farID) && !getOutStream(stream.farID))
				addPeerToSwarm(stream.farID);
				
			dispatchEvent(new PeerManagerEvent(PeerManagerEvent.PUBLIC_PEER_CONNECTED, stream.farID));
		}		
		
		private function addPeerToSwarm(peerId:String):void 
		{
			logger.log('Adding new peer: ' + peerId);
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
			
			logger.log('onReceiveData() command=' + command, 'parameters: ', params, 'peer ID: ',peerId );
			
			switch(command)
			{
				case SwarmCommandType.PARSE_BROADCAST:
					
					Cc.log('Received broadcast data: ' + params.toString());
					dispatchEvent(new PeerManagerEvent(PeerManagerEvent.BROADCAST_RECEIVED, {peerId:peerId, message:params.toString()}));
					//broadcast(params, peerId);
					break;
					
				case SwarmCommandType.CREATE_PRIVATE_CONNECTION:
					var privateReqId:String = params.shift(); // the ID of the peer that the sender wants to connect to.
					// TODO: prompt here if user wants to connect
					if (connection.nearID === privateReqId)
					{
						Cc.log('Request for private connection received, setting up listening stream...');
						createOutStream(StreamType.PUBLISH_PRIVATE, peerId);
						createInStream(StreamType.LISTEN_PRIVATE, peerId);
					}
					else
						Cc.log('Request for private connection received, but not for me.');
					break;
					
				case SwarmCommandType.REPLY_TO_PING:
					Cc.log('Ping received from peer '+peerId+', replying...');
					replyPing(params[0]);
					break;
					
				case SwarmCommandType.PARSE_PING_REPLY:
					Cc.log('Your latency to peer ' + peerId + ' is ' + (getTimer() - Number(params[0])) + 'ms.');
					break;
					
				case SwarmCommandType.ADD_PEER:
					var otherPeerId:String = params.shift();
					// don't add as a new peer if alrady connected to that peer and if new peer is you
					if (!getInStream(StreamType.LISTEN_PUBLIC, otherPeerId) && otherPeerId != connection.nearID)
					{
						Cc.log('New peer in swarm: ' + otherPeerId);
						createInStream(StreamType.LISTEN_PUBLIC, otherPeerId); 
					}
					break;
					
				case SwarmCommandType.PARSE_PRIVATE_DATA:
					// don't check if inteded for me because private swarms only have two peers
					Cc.log('Private data received: ' + params);
					logger.log('Private data received: ' + params);					
					break;
				
				default:
					throw new Error('Unexpected command type received: ' + command);
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
	public var type:String;
	public var stream:NetStream;
	public var peerId:String;
	
	public function StreamVo(type:String, stream:NetStream, peerId:String) 
	{
		this.type = type;
		this.stream = stream;
		this.peerId = peerId;
		
	}
}