package Configuration
{
	public interface IConfigurationProvider
	{
		function load(platform:String, version:String, targets:Array = null, callback:Function = null) : void;
		function get config() : XML;
	}
}