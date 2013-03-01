package main.service.cirrus 
{
	import com.evolutiongaming.games.core.utils.log.EvoLogger;
	import com.evolutiongaming.games.core.utils.log.IEvoLogger;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import main.service.cirrus.enum.SwarmCommandType;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class PeerManager 
	{
		static public const MAX_IN_STREAMS:uint = 3;
		public var debugTf:TextField;
		
		private var logger:IEvoLogger = EvoLogger.getLogger(PeerManager);
		private var inStreams:Vector.<StreamVo> = new <StreamVo>[];
		private var peers:Vector.<Peer> = new <Peer>[];
		private var connection:NetConnection;
		private var outStream:NetStream;
		
		public function PeerManager() 
		{
			
		}
		
	   /**
		* Connects to Cirrus p2p network.
		* @param	peerId	Any peer ID from within the swarm
		*/
	   public function connectToNetwork(connection:NetConnection, peerId:String = null):void
	   {
		   this.connection = connection;
		   createOutStream(connection.nearID);
		   
		   if (peerId)
		   {
			   createInStream(peerId);
		   }
	   }
		
		
		private function createOutStream(peerId:String):void 
		{
			var newStream:NetStream = new NetStream(connection, NetStream.DIRECT_CONNECTIONS);
			newStream.addEventListener(NetStatusEvent.NET_STATUS, onOutboundNetStatus);
			var client:Object = { };
			client.onPeerConnect = onPeerConnect;
			client.onNetStatus = onOutboundNetStatus;
			newStream.client = client;
			newStream.publish('publishStream'+peerId);
			outStream = newStream;
			
			logger.debug('publishing to ', 'publishStream'+peerId);			
		}
		
		private function createInStream(peerId:String):void 
		{
			var newStream:NetStream = new NetStream(connection, peerId);
			newStream.addEventListener(NetStatusEvent.NET_STATUS, onInboundNetStatus);
			var client:Object = { };
			client.onReceiveData = onReceiveData;
			client.onNetStatus = onInboundNetStatus;
			newStream.client = client;
			newStream.play('publishStream'+peerId);
			inStreams.push(new StreamVo(newStream, peerId));
			
			logger.debug('listening on ', 'publishStream'+peerId);
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
		
		public function broadcast(params:Array, exceptId:String = null):void
		{
			logger.debug("broadcast except: ", exceptId, "; params: ", params);
			logger.debug(o.peerId, exceptId);
			params.unshift(// TODO: save broadcast id hashes);
			params.unshift(connection.nearID);
			params.unshift(SwarmCommandType.BROADCAST);
			params.unshift("onReceiveData");
			outStream.send.apply(null, params);
		}
		
		private function sendToPeer(peerId:String):void
		{
			var stream:NetStream = outStream.send("onReceiveData", SwarmCommandType.PRIVATE, connection.nearID, peerId);
		}
		
		private function getInStreamById(id:String):NetStream
		{
			for each (var o:StreamVo in inStreams) 
			{
				if (o.peerId === id)
					return o.stream
			}
			return null;
		}
		
		private function onPeerConnect(stream:NetStream):void 
		{
			logger.debug("onPeerConnect(), far id:", stream.farID);
			
			if(!getInStreamById(stream.farID))
				addPeerToSwarm(stream.farID);
		}		
		
		private function addPeerToSwarm(peerId:String):void 
		{
			if (inStreams.length < MAX_IN_STREAMS)
			{				
				createInStream(peerId);
			}
			//else
				// TODO: tell other peer to listen
			
		}
		
		private function onReceiveData(...params):void
		{
			var castHash:String = params.shift();
			var command:int = int(params.shift());
			var peerId:String = params.shift();
			
			trace(params.length);
			debugTf.text += '\nonReceiveData() command=' + command + '; parameters: ' + params + '; peer ID: ' + peerId ;
			logger.debug('onReceiveData() command=' + command, 'parameters: ', params, 'peer ID: ',peerId );
			
			switch(command)
			{
				case SwarmCommandType.BROADCAST:
					
					broadcast(params, peerId);
					break;
					
				case SwarmCommandType.PRIVATE:
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
	public var stream:NetStream;
	public var peerId:String;
	public function StreamVo(stream:NetStream, peerId:String)
	{
		this.stream = stream;
		this.peerId = peerId;
		
	}
}