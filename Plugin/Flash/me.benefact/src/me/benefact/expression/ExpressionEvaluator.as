package me.benefact.expression
{
	public class ExpressionEvaluator
	{
		private namespace _ns = "http://platform.benefact.me/Schema/Expressions.xsd";
		private var _resolver:IExpressionResolver = null;
		
		public function ExpressionEvaluator(resolver:IExpressionResolver = null)
		{
			_resolver = resolver;
		}
		
		public function get resolver() : IExpressionResolver {
			return _resolver;
		}
		
		public function set resolver(value:IExpressionResolver) : void {
			_resolver = value;
		}
		
		public function evaluate(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var result:Boolean;
			var equals:Boolean = expression.attribute("Equals").text() as Boolean;
			
			switch(expression.name){
				case "Any":
					result = evaluateAny(expression, ctx);
					break;
				case "All":
					result = evaluateAll(expression, ctx);
					break;
				case "Reference":
					result = evaluateReference(expression, ctx);
					break;
				case "Regexp":
					result = evaluateRegex(expression, ctx);
					break;
				case "Compare":
					result = evaluateCompare(expression, ctx);
					break;
				case "Contains":
					result = evaluateContains(expression, ctx);
					break;
				case "StartsWith":
					result = evaluateStartsWith(expression, ctx);
					break;
				case "EndsWith":
					result = evaluateEndsWith(expression, ctx);
					break;
				case "FirstIndexOf":
					result = evaluateFirstIndexOf(expression, ctx);
					break;
				case "LastIndexOf":
					result = evaluateLastIndexOf(expression, ctx);
					break;
				default:
					return false;
			}
			
			return result == equals;
		}
		
		public function evaluateAny(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			for each(var expression:XML in expression.elements())
			if(evaluate(expression, ctx.copy()))
				return true;
			
			return false;
		}
		
		public function evaluateAll(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			for each(var expression:XML in expression.elements())
				if(!evaluate(expression, ctx.copy()))
					return false;
			
			return true;
		}
		
		public function evaluateReference(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			if(_resolver == null)
				return false;
			
			var name:String = expression.attribute("Name").text();
			
			if(name == null || name == "")
				return false;
			
			var expression:XML = _resolver.resolve(name);
			
			if(expression == null)
				return false;
			
			
			return evaluateAll(expression.elements(), ctx);
		}
		
		public function evaluateRegex(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var pattern:String = getValueNode(expression, "Pattern");
			var and:XML = expression.child("And");
			
			if(source == null || pattern == null)
				return false;

			var regex:RegExp = new RegExp(pattern);
			var result:Array = regex.exec(source);
			
			if(result == null)
				return false;
			
			if(and == null)
				return true;
			
			var captures:Vector.<String> = new Vector.<String>();
			
			for each(var capture:String in result[0])
				captures.push(capture);
				
			return evaluate(and, ctx.copy(source, captures));
		}
			
		public function evaluateCompare(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var value:String = getValueNode(expression, "Value");
			
			if(source == null || value == null)
				return false;
			
			return source == value;
		}
		
		public function evaluateContains(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var value:String = getValueNode(expression, "Value");
			
			if(source == null || value == null)
				return false;
			
			return source.indexOf(value) != -1;
		}
		
		public function evaluateStartsWith(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var value:String = getValueNode(expression, "Value");
			
			if(source == null || value == null)
				return false;
			
			return source.indexOf(value) == 0;
		}
		
		public function evaluateEndsWith(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var value:String = getValueNode(expression, "Value");
			
			if(source == null)
				return false;
			
			if(value == null)
				return false;
			
			return source.indexOf(value) == (source.length - value.length);
		}
		
		public function evaluateFirstIndexOf(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var value:String = getValueNode(expression, "Value");
			var index:String = expression.attribute("Index").text();
			
			if(source == null || value == null || index == null)
				return false;
		
			return source.indexOf(value) == (index as int);
		}
		
		public function evaluateLastIndexOf(expression:XML, ctx:ExpressionContext) : Boolean {
			use namespace _ns;
			
			var source:String = ctx.getComponent(expression.attribute("Source").text());
			var value:String = getValueNode(expression, "Value");
			var index:String = expression.attribute("Index").text();
			
			if(source == null || value == null || index == null)
				return false;
			
			return source.lastIndexOf(value) == (index as int);
		}
		
		private static function getValueNode(expression:XML, nodeName:String) : String {
			use namespace _ns;
			
			var value:String = null;
			var valueNodes:XMLList = expression.child(nodeName);
			
			for each(var valueNode:XML in valueNodes){
				var textValue:String = valueNode.text();
				
				if(textValue != null && textValue != ""){
					value = textValue
				}else if(textValue == null && textValue == ""){
					value = textValue;
				}
			}
			
			return value;
		}
	}
}