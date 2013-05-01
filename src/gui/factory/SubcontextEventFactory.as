package gui.factory 
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
			var dataVo:SubcontextDataVo;
			switch (type)
			{
				case SubcontextEvent.CREATE_NETWORK:
					ret = new SubcontextEvent(SubcontextEvent.CREATE_NETWORK);
					break;
					
				case SubcontextEvent.CONNECT_TO_PEER:
					dataVo = new SubcontextDataVo();
					dataVo.nearId = data['nearId'];
					ret = new SubcontextEvent(SubcontextEvent.CONNECT_TO_PEER, dataVo);
					break;
					
				case SubcontextEvent.PING_PEER:
					dataVo = new SubcontextDataVo();
					dataVo.nearId = data['nearId'];
					ret = new SubcontextEvent(SubcontextEvent.PING_PEER, dataVo);
					break;
					
				case SubcontextEvent.BROADCAST:
					dataVo = new SubcontextDataVo();
					dataVo.message = data['message'];
					ret = new SubcontextEvent(SubcontextEvent.BROADCAST, dataVo);
					break;
				
				case SubcontextEvent.REQUEST_PRIVATE_STREAM:
					dataVo = new SubcontextDataVo();
					dataVo.nearId = data['nearId'];
					ret = new SubcontextEvent(SubcontextEvent.REQUEST_PRIVATE_STREAM, dataVo);
					break;
				
				case SubcontextEvent.SEND_TO_PRIVATE:
					dataVo = new SubcontextDataVo();
					dataVo.nearId = data['nearId'];
					dataVo.message = data['message'];
					ret = new SubcontextEvent(SubcontextEvent.SEND_TO_PRIVATE, dataVo);
					break;
				
				default:
					throw new Error('Unexpected event type "' + type + '" received.');
			}
			
			return ret;
		}
		
	}

}