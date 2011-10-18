package Target
{
	import Expression.IExpressionResolver;

	internal class DefaultExpressionResolver implements IExpressionResolver
	{
		private var _expressions:XML;
		
		public function DefaultExpressionResolver(expressions:XML)
		{
			_expressions = expressions;
		}
		
		public function resolve(name:String) : XML {
			var results:XMLList = _expressions.(attribute("Name") == name);
			
			if(results.length() == 1)
				return results[0];
			
			return null;
		}
	}
}