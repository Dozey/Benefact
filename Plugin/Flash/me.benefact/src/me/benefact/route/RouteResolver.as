package me.benefact.route
{
	import me.benefact.utilities.DomainUtil;
	
	import mx.utils.URLUtil;
	
	public class RouteResolver implements IRouteResolver
	{
		private var _routes:XMLList;
		private var _exactLookup:Vector.<String> = new Vector.<String>();
		private var _wildcardLookup:Vector.<String> = new Vector.<String>();
		private var _includeTopLevelDomain:Boolean = false;
		
		public function RouteResolver(routes:XMLList)
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
		
		protected function get routes() : XMLList {
			return _routes;
		}
		
		public function resolve(url:String) : XML {
			var effectiveHostname:String = resolveHostname(url);
			
			if(effectiveHostname != null)
			{
				var route:XML = resolveRoute(url, URLUtil.getProtocol(url));
				
				if(route != null)
					return route;
			}
			
			return null;
		}
		
		protected function resolveHostname(url:String) : String {
			var hostname:String = URLUtil.getServerName(url);
			var tld:String = DomainUtil.stripSubdomain(hostname);
			var subdomains:Array = hostname.substring(0, hostname.lastIndexOf(tld)).split(".");
			var result:String = null;
			
			do {
				var index:int = -1;
				var exactSearch:String = subdomains.join(".").concat(".").concat(tld);
				var wildcardSearch:String = "*." + exactSearch;
				
				// Try exact lookup
				index = _exactLookup.indexOf(exactSearch);
				
				if(index != -1){
					result = exactSearch;
					break;
				}
				
				index = _wildcardLookup.indexOf(wildcardSearch);
				
				if(index != -1){
					result = wildcardSearch;
					break;
				}
			}while(subdomains.shift() != null);
			
			return result;
		}
			
		protected function resolveRoute(hostname:String, scheme:String) : XML {
			var routes:XMLList = routes.(attribute('Host') == effectiveHostname && attribute("Scheme").split(" ").indexOf(scheme) != -1);
			
			if(routes.length() == 1)
				return routes[0];
			
			return null;
		}
	}
}