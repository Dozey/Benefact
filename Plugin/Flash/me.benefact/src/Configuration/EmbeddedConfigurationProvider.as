package Configuration
{
	internal class EmbeddedConfigurationProvider implements IConfigurationProvider
	{
		private var _factory:Function;
		private var _config:XML;
		
		public function EmbeddedConfigurationProvider(settings:Object)
		{
			validateSettings(settings);
			
			_factory = settings["factory"];
		}
		
		private function validateSettings(settings:Object) : void {
			if(
				settings["factory"] == null ||
				!(settings["factory"] is Function) 
			){
				throw new Error("Invalid settings");
			}
		}
		
		public function get config() : XML {
			return _config;
		}
		
		public function load(platform:String, version:String, targets:Array = null, callback:Function = null) : void {
			var resource:IEmbeddedConfiguration = _factory() as IEmbeddedConfiguration;
			
			if(resource != null){
				try{
					_config = resource.getConfiguration(platform, version, targets);
				}finally{}
			
				
				if(_config != null)
					if(callback != null)
						callback();
			}
		}
		
	}
}