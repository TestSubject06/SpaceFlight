package states 
{
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class ManagedState extends FlxState
	{
		public var passDraw:Boolean = true;
		public var passUpdate:Boolean = false;
		public function recoverControl():void {
			//Do Nothing.
		}
	}
}