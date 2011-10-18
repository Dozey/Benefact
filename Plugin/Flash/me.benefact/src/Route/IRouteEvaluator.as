package Route
{
	import Expression.ExpressionEvaluator;

	public interface IRouteEvaluator
	{
		function get resolver() : IRouteResolver;
		function set resolver(value:IRouteResolver) : void;
		function get evaluator() : ExpressionEvaluator;
		function set evaluator(value:ExpressionEvaluator) : void;
		function evaluate(url:String, state:Object = null) : Boolean;
	}
}