package Route
{
	public interface IRouteResolver
	{
		function resolve(url:String): XML;
	}
}