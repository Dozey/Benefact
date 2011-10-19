package me.benefact.configuration
{
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	import mx.utils.*;
	
	internal class CachedConfiguraitonProvider implements IConfigurationProvider
	{		
		private var _provider:IConfigurationProvider;
		private var _lifetime:int;
		private var _compress:Boolean;
		private var _store:SharedObject;
		private var _config:XML;
		
		public function CachedConfiguraitonProvider(settings:Object)
		{
			validateSettings(settings);
			
			_provider = settings["provider"] as IConfigurationProvider;
			_lifetime = settings["lifetime"] as int;
			_compress = settings["compress"] as Boolean;
			_store = SharedObject.getLocal(settings["store"]["name"], settings["store"]["path"]);			
		}
		
		private function validateSettings(settings:Object) : void {
			if(
				settings["provider"] == null ||
				settings["lifetime"] == null ||
				settings["store"] == null ||
				settings["store"]["name"] == null
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
			var date:Date = new Date();
			
			if(_store.data.updated != null && _store.data.version != null && _store.data.compression != null){
				if((_store.data.updated as int + _lifetime as int) > Math.round(date.getTime()/1000) && _store.data.version == version){
					try{
						if(_store.data.compression){
							_config = new XML(decompress(_store.data.cache));
						}else{
							_config = new XML(_store.data.cache);
						}
					}finally{}
					
					if(_config != null){
						loadedImpl(new AsyncContext(callback));
						return;
					}
				}
			}
			
			var ctx:AsyncContext = new AsyncContext(callback);
			_provider.load(platform, version, targets, function(event:Event) : void { loadedImpl(ctx) });
		}
		
		private function loadedImpl(ctx:AsyncContext) : void {
			_config = _provider.config;
			
			if(_config != null){
				_store.data.updated = (new Date().getTime()/1000);
				_store.data.version = _config.attribute("Version");
				_store.data.compression = _compress;
				
				if(_compress){
					_store.data.settings = compress(_config.toXMLString());
				}else{
					_store.data.settings = _config.toXMLString();
				}
				
				_store.flush();
				
				if(ctx.callback !=  null)
					ctx.callback();
			}
		}
		
		private function compress(value:String) : String {
			var encoder:Base64Encoder = new Base64Encoder();
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.compress();
			encoder.encodeBytes(buffer);
			
			return encoder.toString();
		}
		
		private function decompress(value:String) : String {
			var decoder:Base64Decoder = new Base64Decoder();
			var buffer:ByteArray = null;
			decoder.decode(value);
			buffer = decoder.toByteArray();
			buffer.uncompress();
			
			return buffer.toString();
		}
	}
}

class AsyncContext {
	public var callback:Function;
	
	public function AsyncContext(callback:Function){
		this.callback = callback;
	}
}