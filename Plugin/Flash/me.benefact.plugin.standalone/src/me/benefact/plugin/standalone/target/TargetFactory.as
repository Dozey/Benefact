package me.benefact.plugin.standalone.target
{
	import me.benefact.target.ITarget;
	import me.benefact.plugin.standalone.target.links.LinksTarget;
	
	public class TargetFactory
	{
		public function TargetFactory()
		{
		}
		
		public function createTarget(name:String, spec:Object) : ITarget {
			switch(name){
				case "links":
					return new LinksTarget(spec);
			}
			
			return null;
		}
	}
}