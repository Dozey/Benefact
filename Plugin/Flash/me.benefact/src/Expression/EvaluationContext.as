package Expression
{
	public class EvaluationContext
	{
		private var _route:XML;
		private var _url:String;
		private var _value:String;
		private var _result:Vector.<String>;
		private var _state:Object;
		
		public function EvaluationContext(route:XML, url:String, value:String, result:Vector.<String>, state:Object = null){
			_route = route;
			_url = url;
			_value = value;
			_result = result;
			_state = state;
		}
		
		public function get route() : XML {
			return _route;
		}
		
		public function get url() : String {
			return _url;
		}
		
		public function get host() : String {
			return null;
		}
		
		public function get path() : String {
			return null;
		}
		
		public function get query() : String {
			return null;
		}
		
		public function get value() : String {
			return _value;
		}
		
		public function get state() : Object {
			return _state;
		}
		
		public function set state(value:Object) : void {
			_state = value;
		}
		
		public function set result(value:String) : void {
			_result = new Vector.<String>();
			_result.push(value);
		}
		
		public function get result() : String {
			if(result.length > 0)
				return _result[0];
			
			return null;
		}
		
		public function getResult(offset:int = 0) : String {
			if(offset < _result.length){
				return _result[offset];
			}
			
			return null;
		}
		
		public function getComponent(name:String) : String {
			switch(name){
				case "url":
					return url;
				case "host":
					return host;
				case "path":
					return path;
				case "query":
					return query;
				case "parent":
					return result;
				default:
					if(name.indexOf("result:") == 0)
						return getResult(name.substr(8) as int);
			}
			
			return null;
		}
		
		public function copy(value:String = null, result:Vector.<String> = null) : EvaluationContext {
			var newValue:String = value; 
			var newResult:Vector.<String> = result; 
				
			if(newValue == null)
				newValue = _value;
				
			if(newResult == null)
				newResult = result;
			
			return new EvaluationContext(_route, _url, newValue, newResult, _state);
		}
	}
}