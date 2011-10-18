package Configuration
{
	public interface IEmbeddedConfiguration
	{
		function getConfiguration(platform:String, version:String, targets:Array = null) : XML;
	}
}