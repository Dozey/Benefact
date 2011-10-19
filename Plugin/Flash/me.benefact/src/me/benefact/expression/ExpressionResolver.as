package me.benefact.expression
{

	public class ExpressionResolver implements IExpressionResolver
	{
		private var _expressions:XMLList;
		
		public function ExpressionResolver(expressions:XMLList)
		{
			_expressions = expressions;
		}
		
		protected function get expressions() : XMLList{
			return _expressions;
		}
		
		public function resolve(name:String) : XML {
			var results:XMLList = _expressions.(attribute("Name") == name);
			
			if(results.length() == 1)
				return results[0];
			
			return null;
		}
	}
}