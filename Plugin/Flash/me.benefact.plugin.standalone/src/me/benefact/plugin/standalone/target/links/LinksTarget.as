package me.benefact.plugin.standalone.target.links
{
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import me.benefact.expression.ExpressionEvaluator;
	import me.benefact.expression.ExpressionResolver;
	import me.benefact.plugin.standalone.target.links.resource.Resources;
	import me.benefact.route.RouteEvaluator;
	import me.benefact.target.*;
	import me.benefact.utilities.*;
	
	import mx.utils.*;
	
	public class LinksTarget extends TargetBase implements ITarget
	{
		private static const TARGET_NAME:String = "links";
		private var _rewriteFormat:String;
		private var _run:Function;
		
		public function LinksTarget(settings:Object)
		{
			super(settings);

			evaluator = new LinkRouteEvaluator(
				new LinkRouteResolver(target.Routes.elements("Route")),
				new ExpressionEvaluator(
					new ExpressionResolver(target.Expressions.elements("Expression"))
				)
			);
		
			use namespace NS;
			
			_rewriteFormat = target.attribute("RewriteFormat");
			
			if(_rewriteFormat == null)
				throw new Error("Missing RewriteFormat");
		}
		
		public function get name():String
		{
			return TARGET_NAME;
		}
		
		public function initialize():void
		{
			var classIdentifier:String = "$$" + ExternalInterface.objectID + "$" + UIDUtil.createUID().replace(/\-/g, "");
			var callbackIdentifier:String = "$$" + ExternalInterface.objectID + "$" + UIDUtil.createUID().replace(/\-/g, "");
			var loader:String = (Resources.Loader as ByteArray).toString();
			var payload:String = StringUtil.substitute((Resources.Payload as ByteArray).toString(), classIdentifier);
			var payloadRunner:String = StringUtil.substitute("new {0}('{1}', '{2}').run", classIdentifier, ExternalInterface.objectID, callbackIdentifier);
			ExternalInterface.addCallback(callbackIdentifier, evaluateUrl);
			ExternalInterface.call(loader, payload);
			
			
			_run = function() : void {
				ExternalInterface.call(payloadRunner);
			};
		}
				
		public function run():void
		{
			_run();
		}
		
		private function evaluateUrl(url:String) : String {
			var state:Object = {"tag":""};
			if(match(url, state)){
				return rewrite(url, state.tag);
			}
			
			return null;
		}
		
		private function rewrite(url:String, tag:String = "") : String {
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(url);
			
			url = url.replace("{url}", escape(encoder.toString()));
			url = url.replace("{tag}", tag);
			
			return url;
		}
	}
}

import me.benefact.expression.ExpressionContext;
import me.benefact.expression.ExpressionEvaluator;
import me.benefact.plugin.standalone.target.links.LinksTarget;
import me.benefact.utilities.DomainUtil;
import me.benefact.route.*;
import me.benefact.utilities.*;
import mx.managers.BrowserManager;

internal namespace NS = "http://platform.benefact.me/Schema/Links.xsd"; 

class LinkRouteResolver extends RouteResolver {
	public function LinkRouteResolver(routes:XMLList){
		super(routes);	
	}
	
	protected override function resolveRoute(hostname:String, scheme:String) : XML {
		var route:XML = super.resolveRoute(hostname, scheme);
		
		use namespace NS;
		
		if(route != null){		
			var pageUrl:String = BrowserManager.getInstance().url;
			var pageHostname:String = DomainUtil.getDomain(pageUrl);
			var hostExclusion:String = route.attribute("Exclude");
			var matchExclusions:XML = route.Exclusions;
			
			if(hostExclusion != null){
				switch(hostExclusion){
					case "none":
						return route;
					case "self":						
						if(StringUtils.endsWith(pageHostname, hostname))
							return null;
					default:
						return null;
				}
			}
			
			if(matchExclusions != null){
				var evaluator:ExpressionEvaluator = new ExpressionEvaluator();
				
				for each(var exclusion:XML in matchExclusions.Exclude){
					if(evaluator.evaluateAll(exclusion, new ExpressionContext(route, pageUrl, pageHostname, new Vector.<String>())))
						return null;
				}
			}
		}
		
		return route;
	}
}

class LinkRouteEvaluator extends RouteEvaluator {
	
	public function LinkRouteEvaluator(resolver:IRouteResolver, evaluator:ExpressionEvaluator)
	{
		super(resolver, evaluator);
	}
	
	protected override function evaluateRoute(ctx:ExpressionContext) : Boolean {
		use namespace NS;
		
		if(super.evaluateRoute(ctx)){
			if(ctx.state != null){
				ctx.state.tag = ctx.route.attribute("Tag");
			}
			
			return true;
		}
		
		return false;
	}
}