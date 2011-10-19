package me.benefact.route
{
	import me.benefact.expression.ExpressionContext;
	import me.benefact.expression.ExpressionEvaluator;
	
	
	public class RouteEvaluator implements IRouteEvaluator
	{
		private var _resolver:IRouteResolver = null;
		private var _evaluator:ExpressionEvaluator = null;
		
		public function RouteEvaluator(resolver:IRouteResolver, evaluator:ExpressionEvaluator)
		{
			_resolver = resolver;
			_evaluator = evaluator;
		}
		
		public function get resolver() : IRouteResolver {
			return _resolver;			
		}
		
		public function set resolver(value:IRouteResolver) : void {
			_resolver = value;
		}
		
		public function get evaluator() : ExpressionEvaluator {
			return _evaluator;
		}
		
		public function set evaluator(value:ExpressionEvaluator) : void {
			_evaluator = value;	
		}
		
		public function evaluate(url:String, state:Object = null) : Boolean {
			var route:XML = _resolver.resolve(url);
			
			if(route == null)
				return false;
			
			var ctx:ExpressionContext = new ExpressionContext(route, url, url, new Vector.<String>(), state);
			
			return evaluateRoute(ctx);
		}
		
		protected function evaluateRoute(ctx:ExpressionContext) : Boolean {
			for each(var expression:XML in ctx.route.child("Match")){
				var result:Boolean = false;

				if(evaluateMatch(expression, ctx))
					return true;
			}
			
			return false;
		}
		
		protected function evaluateMatch(expression:XML, ctx:ExpressionContext) : Boolean {
			var result:Boolean = false;
			
			try{
				result = _evaluator.evaluateAll(expression, ctx);
			}finally{}
			
			return result;
		}
	}
}