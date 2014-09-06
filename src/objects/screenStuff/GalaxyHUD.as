package objects.screenStuff 
{
	import assets.graphicAssets;
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class GalaxyHUD extends FlxSprite 
	{
		private var lights:Array;
		private var lightDelays:Array;
		private var spinningIcon:FlxSprite;
		private var spinDelay:Number = 0;
		private var lightAnimSwitcher:int = 0;
		private var coordinatesFont:FlxBitmapFont;
		private var numbers:Object;
		private var xCoordN:Number = 0;
		private var xCoordS:String;
		private var yCoordN:Number = 0;
		private var yCoordS:String;
		private var xDP:int = 3;
		private var yDP:int = 3;
		private var helperSprite:FlxSprite;
		
		public function GalaxyHUD(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, graphicAssets.GALAXY_HUD);
			
			lights = new Array(6);
			for (var i:int = 0; i < 6; i++) {
				//create the light pattern
				//1 2
				//3 4
				//5 6
				//Mod 2 to toggle 0-1, then mult by 8 to get the left or right column.
				//floor the division by two to get a simple 0 0 1 1 2 2 pattern, then mult that by 7 for the row.
				lights[i] = new FlxSprite((8*(i%2))+298 + x, (Math.floor(i/2) * 7) + 3 + y);
				(lights[i] as FlxSprite).loadGraphic(graphicAssets.GHUD_LIGHTS, true, false, 4, 4);
				(lights[i] as FlxSprite).addAnimation("start", [0], 0, false);
				(lights[i] as FlxSprite).addAnimation("redGlow", 	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 12, 12, 12, 12, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 10, false);
				(lights[i] as FlxSprite).addAnimation("orangeGlow", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 25, 25, 25, 25, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13], 10, false);
				(lights[i] as FlxSprite).addAnimation("yellowGlow", [26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 38, 38, 38, 38, 38, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26], 10, false);
				(lights[i] as FlxSprite).addAnimation("limeGlow", 	[39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 51, 51, 51, 51, 51, 51, 50, 49, 48, 47, 46, 45, 44, 43 ,42, 41, 40, 39], 10, false);
				(lights[i] as FlxSprite).addAnimation("greenGlow", 	[52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 64, 64, 64, 64, 64, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52], 10, false);
				(lights[i] as FlxSprite).addAnimation("blueGlow", 	[65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 77, 77, 77, 77, 77, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65], 10, false);
				(lights[i] as FlxSprite).addAnimation("purpleGlow", [78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 90, 90, 90, 90, 90, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78], 10, false);
				(lights[i] as FlxSprite).play("start");
				(lights[i] as FlxSprite).scrollFactor.y = (lights[i] as FlxSprite).scrollFactor.x = 0;
			}
			
			spinningIcon = new FlxSprite(470, 4);
			spinningIcon.loadGraphic(graphicAssets.GHUD_ICON, true, false, 14, 17);
			spinningIcon.addAnimation("sitStill", [0], 0, false);
			spinningIcon.addAnimation("spin", [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 0], 30, false);
			spinningIcon.play("spin");
			spinningIcon.scrollFactor.x = spinningIcon.scrollFactor.y = 0;
			
			lightDelays = new Array(6);
			for (var i:int = 0; i < 6; i++) {
				lightDelays[i] = FlxG.random() * 1.5;
			}
			scrollFactor.x = scrollFactor.y = 0;
			
			coordinatesFont = new FlxBitmapFont(graphicAssets.SHAD_NUMBERS, 12, 11, "1234567890.", 11);
			
			numbers = new Object();
			numbers["0"] = coordinatesFont.getCharacter("0");
			numbers["1"] = coordinatesFont.getCharacter("1");
			numbers["2"] = coordinatesFont.getCharacter("2");
			numbers["3"] = coordinatesFont.getCharacter("3");
			numbers["4"] = coordinatesFont.getCharacter("4");
			numbers["5"] = coordinatesFont.getCharacter("5");
			numbers["6"] = coordinatesFont.getCharacter("6");
			numbers["7"] = coordinatesFont.getCharacter("7");
			numbers["8"] = coordinatesFont.getCharacter("8");
			numbers["9"] = coordinatesFont.getCharacter("9");
			numbers["."] = coordinatesFont.getCharacter(".");
			
			numbers["0"].scrollFactor.make(0, 0);
			numbers["1"].scrollFactor.make(0, 0);
			numbers["2"].scrollFactor.make(0, 0);
			numbers["3"].scrollFactor.make(0, 0);
			numbers["4"].scrollFactor.make(0, 0);
			numbers["5"].scrollFactor.make(0, 0);
			numbers["6"].scrollFactor.make(0, 0);
			numbers["7"].scrollFactor.make(0, 0);
			numbers["8"].scrollFactor.make(0, 0);
			numbers["9"].scrollFactor.make(0, 0);
			numbers["."].scrollFactor.make(0, 0);
			
		}
		override public function update():void 
		{
			//Updates
			super.update();
			spinningIcon.update();
			for (var i:int = 0; i < 6; i++) {
				(lights[i] as FlxSprite).update();
			}
			
			//Timers
			spinDelay -= FlxG.elapsed;

			//Animation control
			if (spinningIcon.animationName == "spin" && spinningIcon.finished) {
				spinningIcon.play("sitStill");
				spinDelay = (FlxG.random() * 5) + 2;
			}
			if (spinDelay <= 0) {
				spinningIcon.play("spin");
			}
			
			for (i = 0; i < 6; i++) {
				if ((lights[i] as FlxSprite).finished) {
					lightDelays[i] -= FlxG.elapsed;
					if (lightDelays[i] <= 0) {
						(lights[i] as FlxSprite).play(randomLightAnim());
						lightDelays[i] = (FlxG.random() * 5);
					}
				}
			}
		}
		override public function draw():void 
		{
			super.draw();
			spinningIcon.draw();
			for (var i:int = 0; i < 6; i++) {
				(lights[i] as FlxSprite).draw();
			}
			drawCoords();
		}
		override public function preUpdate():void 
		{
			super.preUpdate();
			spinningIcon.preUpdate();
			for (var i:int = 0; i < 6; i++) {
				(lights[i] as FlxSprite).preUpdate();
			}
		}
		override public function postUpdate():void 
		{
			super.postUpdate();
			spinningIcon.postUpdate();
			for (var i:int = 0; i < 6; i++) {
				(lights[i] as FlxSprite).postUpdate();
			}
		}
		private function randomLightAnim():String {
			lightAnimSwitcher = FlxU.floor(FlxG.random() * 6);
			switch(lightAnimSwitcher) {
				case 0:
					return "redGlow";
					break;
				case 1:
					return "orangeGlow";
					break;
				case 2:
					return "yellowGlow";
					break;
				case 3:
					return "limeGlow";
					break;
				case 4:
					return "greenGlow";
					break;
				case 5:
					return "blueGlow";
					break;
				case 6:
					return "purpleGlow";
					break;
			}
			return "start";
		}
		public function updateCoords(xCoords:Number, yCoords:Number):void {
			xCoordS = "" + xCoords;
			yCoordS = "" + yCoords;
			xCoordN = xCoords;
			yCoordN = yCoords;
		}
		public function drawCoords():void {
			if (xCoordN >= 100) {
				xDP = 3;
			}
			if (xCoordN >= 10 && xCoordN < 100) {
				xDP = 2;
			}
			if (xCoordN >= 0 && xCoordN < 10) {
				xDP = 1;
			}
			if (yCoordN >= 100) {
				yDP = 3;
			}
			if (yCoordN >= 10 && yCoordN < 100) {
				yDP = 2;
			}
			if (yCoordN >= 0 && yCoordN < 10) {
				yDP = 1;
			}
			if (xCoordN % 1 == 0) {
				//We're a perfectly flat number. This means there's no decimal place. So let's add one.
				xCoordS += ".0";
			}
			if (yCoordN % 1 == 0) {
				//We're a perfectly flat number. This means there's no decimal place. So let's add one.
				yCoordS += ".0";
			}
			//X
			for (var i:int = 0; i < xCoordS.length; i++) {
				if (i > xDP + 1)
					break;
				helperSprite = numbers[xCoordS.charAt(i)];
				if (i == xDP+1)
					helperSprite.x = ((12 * (i + (3 - xDP))) + 584) - 8;
				else
					helperSprite.x = (12 * (i + (3 - xDP))) + 584;
				helperSprite.y = 27;
				helperSprite.color = 0x7FC0EB;
				helperSprite.draw();
			}
			//Y
			for (i = 0; i < yCoordS.length; i++) {
				if (i > yDP + 1)
					break;
				helperSprite = numbers[yCoordS.charAt(i)];
				if (i == yDP+1)
					helperSprite.x = ((12 * (i + (3 - yDP))) + 584) - 8;
				else
					helperSprite.x = (12 * (i + (3 - yDP))) + 584;
				helperSprite.y = 40;
				helperSprite.color = 0x7FC0EB;
				helperSprite.draw();
			}
		}
	}
}