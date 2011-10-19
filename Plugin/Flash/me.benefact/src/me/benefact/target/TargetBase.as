package me.benefact.target
{
	import me.benefact.expression.*;
	
	import me.benefact.route.*;

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
			_evaluator = settings["evaluator"];
			
			if(_evaluator == null || !(_evaluator is IRouteEvaluator)){
				_evaluator = new RouteEvaluator(
					new RouteResolver(_target.Routes),
					new ExpressionEvaluator(
						new ExpressionResolver(_target.Expressions)
					)
				);
			}
		}
		
		protected function get target() : XML {
			return _target;
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