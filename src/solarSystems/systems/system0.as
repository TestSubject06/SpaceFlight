package solarSystems.systems 
{
	import objects.solarSystemObjects.Planet;
	import states.SolarSystem;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class system0 extends SolarSystem 
	{
		override public function create():void 
		{
			sunType = "red";
			planetsGroup.add(new Planet("rock", 1, 4));
			planetsGroup.add(new Planet("water2", 3, 4));
			planetsGroup.add(new Planet("water", 4, 4));
			planetsGroup.add(new Planet("ice", 6, 4));
			planetsGroup.add(new Planet("ice", 7, 4));
			super.create();
		}
		override public function update():void 
		{
			super.update();
		}
		override public function destroy():void 
		{
			Registry.exitStar = 0;
			super.destroy();
		}
	}
}