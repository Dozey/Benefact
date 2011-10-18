package Target
{
	import Expression.*;
	
	import Route.*;

	public class TargetBase
	{
		private var _name:String;
		private var _target:XML;
		private var _evaluator:IRouteEvaluator;
		
		public function TargetBase(settings:Object)
		{
			if(settings["target"] == null)
				throw new Error("Invalid configuration");

			_target = settings["target"];
			_evaluator = new DefaultRouteEvaluator(
				new DefaultRouteResolver(_target.child("Routes")),
				new ExpressionEvaluator(
					new DefaultExpressionResolver(_target.child("Expressions"))
				)
			);
		}
		
		protected function get evaluator() : IRouteEvaluator {
			return _evaluator;
		}
		
		protected function set evaluator(value:IRouteEvaluator) : void {
			_evaluator = value;
		}
		
		protected function match(url:String, state:Object = null) : Boolean {
			if(_evaluator == null)
				return false;
			
			return _evaluator.evaluate(url, state);
		}
	}
}