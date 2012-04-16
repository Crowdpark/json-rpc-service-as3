package com.crowdpark.net.rpc.json
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Francis Varga
	 */
	public interface InterfaceJsonRpcClient extends IEventDispatcher
	{
		function get url():String;
		function set url(url : String) : void;
		function send(sendData:Object=null) : void;
		function get onResultCallback() : Function;
		function set onResultCallback(onResultCallback : Function) : void;
		function get onFaultCallback() : Function;
		function set onFaultCallback(onFaultCallback : Function) : void;
		function get method() : String;
		function set method(method : String) : void;
		function get params() : Array;
		function set params(params : Array) : void;
	}
}
