package objects.solarSystemObjects 
{
	import assets.graphicAssets;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Planet extends FlxSprite 
	{
		public var type:String = "";
		public var pmass:Number = 0;
		public var bio:int = 0;
		public var mineral:int = 0;
		public var orbit:int = 0;
		public var perlinSeed:Number = 42352;
		public function Planet(planetType:String, planetOrbit:int, seed:Number) 
		{
			type = planetType;
			orbit = planetOrbit;
			makePlanet();
			antialiasing = true;
			perlinSeed = seed;
		}
		private function makePlanet():void {
			switch(type) {
				case "rock":
					loadGraphic(graphicAssets.ROCKPLANET_GFX);
				break;
				case "ice":
					loadGraphic(graphicAssets.ICEPLANET_GFX);
				break;
				case "water":
					loadGraphic(graphicAssets.WATERPLANET_GFX);
				break;
				case "water2":
					loadGraphic(graphicAssets.WATERPLANET2_GFX);
				break;
			}
		}
	}
}