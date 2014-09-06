package objects.solarSystemObjects 
{
	import assets.graphicAssets;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class redSun extends FlxGroup 
	{
		private var firstSun:FlxSprite;
		private var secondSun:FlxSprite;
		private var thirdSun:FlxSprite;
		private var sunBacking:FlxSprite;
		private var sunToggle:int = 0;
		public function redSun() 
		{
			sunBacking = new FlxSprite(0, 0, graphicAssets.STARBACKING_GFX);
			
			firstSun = new FlxSprite();
			firstSun.loadGraphic(graphicAssets.REDSUN_GFX, false, false, 194, 194);
			firstSun.blend = "add";
			
			secondSun = new FlxSprite();
			secondSun.loadGraphic(graphicAssets.REDSUN_GFX, false, false, 194, 194);
			secondSun.frame = 1;
			secondSun.blend = "add";
			secondSun.alpha = 0;
			
			thirdSun = new FlxSprite();
			thirdSun.loadGraphic(graphicAssets.REDSUN_GFX, false, false, 194, 194);
			thirdSun.frame = 2;
			thirdSun.blend = "add";
			thirdSun.alpha = 0;
			
			add(sunBacking);
			add(firstSun);
			add(secondSun);
			add(thirdSun);
		}
		override public function update():void 
		{
			switch(sunToggle) {
				case 0:
					firstSun.alpha -= .02;
					secondSun.alpha += .02;
				break;
				
				case 1:
					secondSun.alpha -= .02;
					thirdSun.alpha += .02;
				break;
				
				case 2:
					thirdSun.alpha -= .02;
					firstSun.alpha += .02;
				break;
			}
			if (firstSun.alpha <= 0 && thirdSun.alpha <= 0) {
				sunToggle = 1;
			}
			if (firstSun.alpha <= 0 && secondSun.alpha <= 0) {
				sunToggle = 2;
			}
			if (secondSun.alpha <= 0 && thirdSun.alpha <= 0) {
				sunToggle = 0;
			}
			sunBacking.x = firstSun.x +5;
			sunBacking.y = firstSun.y +5;
			super.update();
		}
	}
}