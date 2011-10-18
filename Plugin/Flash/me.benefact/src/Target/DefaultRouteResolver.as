package Target
{
	import Route.IRouteResolver;
	import Utilities.DomainUtil;
	
	import mx.utils.URLUtil;
	
	public class DefaultRouteResolver implements IRouteResolver
	{
		private var _routes:XML;
		private var _exactLookup:Vector.<String> = new Vector.<String>();
		private var _wildcardLookup:Vector.<String> = new Vector.<String>();
		private var _includeTopLevelDomain:Boolean = false;
		
		public function DefaultRouteResolver(routes:XML)
		{
			_routes = routes;
			
			for each(var route:XML in routes){
				var domain:String = route.attribute("Host");
				
				if(domain.indexOf("*") == 0){
					_wildcardLookup.push(domain.substring(1));
				}else{
					_exactLookup.push(domain);
				}
			}
		}
		
		public function resolve(url:String) : XML {
			var hostname:String = URLUtil.getServerName(url);
			var tld:String = DomainUtil.stripSubdomain(hostname);
			var subdomains:Array = hostname.substring(0, hostname.lastIndexOf(tld)).split(".");
			var search:String = null;
			
			do {
				var index:int = -1;
				var exactSearch:String = subdomains.join(".").concat(".").concat(tld);
				var wildcardSearch:String = "*." + exactSearch;
				
				// Try exact lookup
				index = _exactLookup.indexOf(exactSearch);
				
				if(index != -1){
					search = exactSearch;
					break;
				}
				
				index = _wildcardLookup.indexOf(wildcardSearch);
				
				if(index != -1){
					search = wildcardSearch;
					break;
				}
			}
			while(subdomains.shift() != null);
			
			if(search != null)
			{
				var route:XML = _routes.Route.(attribute('Host') == search && attribute("Scheme").split(" ").indexOf(scheme) != -1)[0];
				
				if(route != null)
					return route;
			}
			
			return null;
		}
	}
}