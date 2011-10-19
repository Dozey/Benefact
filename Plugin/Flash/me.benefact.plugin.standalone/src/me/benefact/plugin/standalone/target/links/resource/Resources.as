package me.benefact.plugin.standalone.target.links.resource
{
	public final class Resources
	{	
		[Embed(source="src/Loader.js", mimeType="application/octet-stream")]
		public static const Loader:Class;
		
		[Embed(source="src/Payload.js", mimeType="application/octet-stream")]
		public static const Payload:Class;
	}
}