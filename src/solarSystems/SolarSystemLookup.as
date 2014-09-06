package solarSystems 
{
	import org.flixel.FlxState;
	import solarSystems.systems.*;
	import states.ManagedState;
	/**
	 * ...
	 * @author ...
	 */
	public class SolarSystemLookup 
	{
		public static function getSolarSystem(solarID:uint):ManagedState {
			switch(solarID) {
				case 0:
					return new system0;
				break;
			}
			return null;
		}
	}

}