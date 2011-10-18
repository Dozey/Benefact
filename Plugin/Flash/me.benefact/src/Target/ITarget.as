package Target
{
	public interface ITarget
	{
		/**
		 * Name 
		 * @return The target name
		 */
		function get name() : String;
		
		/**
		 * Initialize
		 * Initialzies the Target
		 */
		function initialize() : void;
		
		/**
		 * Run 
		 * Runs the target
		 */
		function run() : void;
	}
}