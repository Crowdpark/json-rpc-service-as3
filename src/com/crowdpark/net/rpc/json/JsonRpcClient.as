package com.crowdpark.net.rpc.json
{
	import com.crowdpark.base.BaseVO;

	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	import flash.events.EventDispatcher;

	/**
	 * @author francis
	 */
	public class JsonRpcClient extends EventDispatcher implements InterfaceJsonRpcClient
	{
		protected var _url : String;
		protected var _serviceEventDispatcher : EventDispatcher = new EventDispatcher();
		protected var _onResultCallback : Function;
		protected var _onFaultCallback : Function;
		protected var _method : String;
		protected var _params : Array;
		protected var _httpService : HTTPService;

		public function send(sendData : Object = null) : void
		{
			_httpService = new HTTPService();
			_httpService.addEventListener(FaultEvent.FAULT, this._onFaultCallback ||= this._onFault);
			_httpService.addEventListener(ResultEvent.RESULT, this._onResultCallback ||= this._onResult);

			_httpService.method = "POST";

			if (this.url.length < 5)
			{
				throw new Error("Url not available");
			}

			_httpService.url = this.url;
			_httpService.contentType = "application/json";
			_httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			var jsonString : String;
			if (sendData)
			{
				jsonString = JSON.stringify(sendData);
			}
			else
			{
				jsonString = JSON.stringify({"id":"1", "method":this.method ||= "App.User.getInitialData", "params":this.params ||= []});
			}
			_httpService.send(jsonString);
		}

		protected function _onResult(event : ResultEvent) : void
		{
			try
			{
				var result : Object = JSON.parse((event.result as String));
			}
			catch(error : Error)
			{
				return;
			}

			var eventDataProvider : Object;
			var eventType : String;

			if (result['error'])
			{
				eventDataProvider = result['error'];
				eventType = JsonRpcClientEvent.FAULT;
			}
			else
			{
				eventDataProvider = result['result'];
				eventType = JsonRpcClientEvent.RESULT;
			}

			var newEvent : JsonRpcClientEvent = new JsonRpcClientEvent(eventType);
			var eventData : BaseVO = new BaseVO();
			eventData.rawData = eventDataProvider;
			newEvent.dataProvider = eventData;

			dispatchEvent(newEvent);
		}

		protected function _onFault(event : FaultEvent) : void
		{
			var newEvent : JsonRpcClientEvent = new JsonRpcClientEvent(JsonRpcClientEvent.FAULT);
			var eventData : BaseVO = new BaseVO();
			eventData.rawData = event.fault;
			newEvent.dataProvider = eventData;
			dispatchEvent(newEvent);
		}

		public function get url() : String
		{
			return this._url;
		}

		public function set url(url : String) : void
		{
			this._url = url;
		}

		public function get onResultCallback() : Function
		{
			return _onResultCallback;
		}

		public function set onResultCallback(onResultCallback : Function) : void
		{
			_onResultCallback = onResultCallback;
		}

		public function get onFaultCallback() : Function
		{
			return _onFaultCallback;
		}

		public function set onFaultCallback(onFaultCallback : Function) : void
		{
			_onFaultCallback = onFaultCallback;
		}

		public function get method() : String
		{
			return _method;
		}

		public function set method(method : String) : void
		{
			_method = method;
		}

		public function get params() : Array
		{
			return _params;
		}

		public function set params(params : Array) : void
		{
			_params = params;
		}
	}
}
