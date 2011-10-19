package me.benefact.configuration
{
	final public class ConfigurationProvider
	{
		public static const CONFIG_CACHED:String = "cached";
		public static const CONFIG_EMBEDDED:String = "embedded";
		public static const CONFIG_REMOTE:String = "remote";
		
		public static function createProvider(settings:Object) : IConfigurationProvider {
			switch(settings["name"]){
				case "cached":
					return new CachedConfiguraitonProvider(settings);
				case "embedded":
					return new EmbeddedConfigurationProvider(settings);
				case "remote":
					return new RemoteConfigurationProvider(settings);
			}
			
			return null;
		}
	}
}