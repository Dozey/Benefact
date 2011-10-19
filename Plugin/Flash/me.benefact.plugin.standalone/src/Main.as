package
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	import me.benefact.configuration.*;
	import me.benefact.target.ITarget;
	import me.benefact.plugin.standalone.target.TargetFactory;
	
	public class Main extends Sprite
	{
		private static const _platform:String = "flash:standalone";
		private static const _version:String = "0.1.1";
		private static const _settingsUrl:String = "http://platform.benefact.me/Settings.xml";
		private static const _store:String = "me.benefact.standalone";
		private static const _supportedTargets:Array = ["links"];
		private var _settings:XML;
		
		public function Main()
		{
			if(!ExternalInterface.available)
				return;
			
			var providerSpec:Object = {
				"name":"remote",
				"url":"http://platform.benefact.me/Settings.xml"
			};
			
			var configProvider:IConfigurationProvider = ConfigurationProvider.createProvider(providerSpec);
			
			if(configProvider != null){
				configProvider.load(_platform, _version, _supportedTargets, function() {
					_settings = configProvider.config;
					
					if(_settings != null)
						initialized();
				});
			}
		}
		
		private function initialized() : void {
			var factory:TargetFactory = new TargetFactory();
			
			for each(var targetSettings:XML in _settings.Targets.elements("Target")){
				try{
					var targetName:String = targetSettings.attribute("Name");
					
					var targetSpec:Object = {
						"target":targetSettings
					};
					
					var target:ITarget = factory.createTarget(targetName, targetSpec);
					
					if(target != null)
						target.initialize(targetSettings);
				}catch(e:Error){ }
			}
		}
	}
}