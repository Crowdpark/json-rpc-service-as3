package com.crowdpark.net.rpc.json
{
	import com.crowdpark.base.BaseDataEvent;

	/**
	 * @author francis
	 */
	public class JsonRpcClientEvent extends BaseDataEvent
	{
		public static const RESULT : String = "JsonRpcClientEvent.RESULT";
		public static const FAULT : String = "JsonRpcClientEvent.FAULT";

		public function JsonRpcClientEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
