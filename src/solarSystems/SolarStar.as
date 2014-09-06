package solarSystems
{
	import assets.graphicAssets;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SolarStar extends FlxSprite 
	{
		public static var COLOR_RED:uint = 0;
		public var seed:Number = 0;
		public var solarID:uint = 0;
		public var solarColor:uint = COLOR_RED;
		public function SolarStar(ID:uint, X:Number = 0, Y:Number = 0, Seed:Number = 0) 
		{
			loadGraphic(graphicAssets.SOLARSTAR_GFX, true);
			addAnimation("Pulse", [0, 2, 0, 1], 10);
			play("Pulse");
			solarID = ID;
			seed = Seed;
		}
		override public function preUpdate():void 
		{
			if (onScreen()) {
				super.preUpdate();
			}
		}
		override public function update():void 
		{
			if (onScreen()) {
				super.update();
			}
		}
		override public function postUpdate():void 
		{
			if (onScreen()) {
				super.postUpdate();
			}
		}
		override public function draw():void 
		{
			if (onScreen()) {
				super.draw();
			}
		}
	}
}