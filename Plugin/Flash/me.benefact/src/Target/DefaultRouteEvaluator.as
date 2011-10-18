package Target
{
	import Expression.EvaluationContext;
	import Expression.ExpressionEvaluator;
	
	import Route.IRouteEvaluator;
	import Route.IRouteResolver;
	
	public class DefaultRouteEvaluator implements IRouteEvaluator
	{
		private var _resolver:IRouteResolver = null;
		private var _evaluator:ExpressionEvaluator = null;
		
		public function DefaultRouteEvaluator(resolver:IRouteResolver, evaluator:ExpressionEvaluator)
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
			
			for each(var expression:XML in route.child("Match")){
				var result:Boolean = false;
				var ctx:EvaluationContext = new EvaluationContext(route, url, url, new Vector.<String>(), state);
				
				try{
					result = _evaluator.evaluateAll(expression, ctx);
				}finally{}
				
				if(result)
					return true;
			}
			
			return false;
		}
	}
}