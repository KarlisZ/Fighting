package common.factory 
{
	import common.event.SubcontextEvent;
	import common.vo.SubcontextDataVo;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class SubcontextEventFactory 
	{
		
		public static function produceEvent(type:String, data:* = null):SubcontextEvent
		{
			var ret:SubcontextEvent
			var dataVo:SubcontextDataVo = new SubcontextDataVo();
			switch (type)
			{
				case SubcontextEvent.CREATE_NETWORK:
					ret = new SubcontextEvent(SubcontextEvent.CREATE_NETWORK);
					break;
					
				case SubcontextEvent.CONNECT_TO_PEER:
					dataVo.nearId = data['nearId'];
					ret = new SubcontextEvent(SubcontextEvent.CONNECT_TO_PEER, dataVo);
					break;
					
				case SubcontextEvent.PING_PEER:
					dataVo.nearId = data['nearId'];
					ret = new SubcontextEvent(SubcontextEvent.PING_PEER, dataVo);
					break;
					
				case SubcontextEvent.BROADCAST:
					dataVo.message = data['message'];
					ret = new SubcontextEvent(SubcontextEvent.BROADCAST, dataVo);
					break;
				
				case SubcontextEvent.REQUEST_PRIVATE_STREAM:
					dataVo.nearId = data['nearId'];
					ret = new SubcontextEvent(SubcontextEvent.REQUEST_PRIVATE_STREAM, dataVo);
					break;
				
				case SubcontextEvent.SEND_TO_PRIVATE:
					dataVo.nearId = data['nearId'];
					dataVo.message = data['message'];
					ret = new SubcontextEvent(SubcontextEvent.SEND_TO_PRIVATE, dataVo);
					break;
				
				case SubcontextEvent.CREATE_TEST_COMBAT_STAGE:
					ret = new SubcontextEvent(SubcontextEvent.CREATE_TEST_COMBAT_STAGE);
					break;
					
				case SubcontextEvent.NEAR_ID_KNOWN:
					dataVo.nearId = data;
					ret = new SubcontextEvent(SubcontextEvent.NEAR_ID_KNOWN, dataVo);
					break;
				
				case SubcontextEvent.PUBLIC_PEER_CONNECTED:
					dataVo.farId = data;
					ret = new SubcontextEvent(SubcontextEvent.PUBLIC_PEER_CONNECTED, dataVo);
					break;
					
				case SubcontextEvent.BROADCAST_RECEIVED:
					dataVo.message = data.message;
					dataVo.nearId = data.peerId;
					ret = new SubcontextEvent(SubcontextEvent.BROADCAST_RECEIVED, dataVo);
					break;
				
				default:
					throw new Error('Unexpected event type "' + type + '" received.');
			}
			
			return ret;
		}
		
	}

}