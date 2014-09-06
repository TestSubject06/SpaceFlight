package
{
	import org.flixel.*;
	import states.MainMenu;
	import states.StateManager;
	import states.Menu1;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class SpaceFlight extends FlxGame
	{
		public function SpaceFlight()
		{
			super(640,480,StateManager,1,60,60);
			forceDebugger = true;
		}
	}
}