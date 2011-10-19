package me.benefact.configuration
{
	import flash.events.Event;
	
	public class ConfigurationEvent extends Event
	{
		private var _userInfo:Array;
		public static const LOADING:String = "loading";
		public static const LOADED:String = "loaded";
		public static const ERROR:String = "error"; 
		
		public function ConfigurationEvent(type:String, bubbles:Boolean, cancelable:Boolean, userInfo:Array=null){
			super(type,bubbles,cancelable);
			
			_userInfo = userInfo;
		}
		
		public function get userInfo() : Array {
			return _userInfo;
		}
		
		public override function clone():Event {
			return new ConfigurationEvent(type, bubbles, cancelable, _userInfo);
		}
	}
}