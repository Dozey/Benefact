package me.benefact.target
{
	import me.benefact.expression.ExpressionEvaluator;
	import me.benefact.expression.ExpressionResolver;
	import me.benefact.route.RouteEvaluator;
	import me.benefact.route.RouteResolver;

	public class DefaultRouteEvaluator extends RouteEvaluator
	{
		public function DefaultRouteEvaluator(target:XML)
		{
			super(
				new RouteResolver(target.Routes.elements()),
				new ExpressionEvaluator(
					new ExpressionResolver(target.Expressions.elements())
				)
			);
		}
	}
}