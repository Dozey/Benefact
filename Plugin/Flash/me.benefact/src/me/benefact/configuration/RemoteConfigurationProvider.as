package me.benefact.configuration
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	
	internal class RemoteConfigurationProvider implements IConfigurationProvider
	{
		private var _url:String;
		private var _config:XML = null;
		
		public function RemoteConfigurationProvider(settings:Object)
		{
			validateSettings(settings);
			
			_url = settings["url"];
		}
		
		private function validateSettings(settings:Object) : void {
			if(
				settings["url"] == null
			){
				throw new Error("Invalid settings");
			}
		}
		
		public function get config() : XML {
			return _config;
		}
		
		public function load(platform:String, version:String, targets:Array = null, callback:Function = null) : void {
			loadImpl(platform, version, targets, callback);
		}
		
		private function loadImpl(platform:String, version:String, targets:Array = null, callback:Function = null) : void {
			var urlRequest:URLRequest = new URLRequest(_url);
			var urlLoader:URLLoader = new URLLoader();
			var urlVariables:URLVariables = new URLVariables();
			urlVariables["platform"] = platform;
			urlVariables["version"] = version;
			urlVariables["targets[]"] = targets;
			urlRequest.method = "GET";
			urlRequest.data = urlVariables;		
			
			var ctx:AsyncContext = new AsyncContext(urlLoader, callback);
			urlLoader.addEventListener(Event.COMPLETE, function(event:Event) : void { loadedImpl(ctx) });
			
			try{
				urlLoader.load(urlRequest);
			}finally{}
		}
		
		private function loadedImpl(ctx:AsyncContext) : void {
			if(ctx.loader.bytesLoaded != 0){
				try{
					_config = null;
					_config = new XML(ctx.loader.data.toString());
				}finally{}
				
				if(_config != null)
					ctx.callback();
			}
		}
	}
}

import flash.net.URLLoader;

class AsyncContext {
	public var loader:URLLoader;
	public var callback:Function;
	
	public function AsyncContext(loader:URLLoader, callback:Function){
		this.loader = loader;
		this.callback = callback;
	}
}