package objects.screenStuff 
{
	import assets.graphicAssets;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class StarmapHUD extends FlxSprite 
	{
		private var top:Boolean = true;
		private var lights:Array;
		private var lightDelays:Array;
		private var spinningIcon:FlxSprite;
		private var spinDelay:Number = 0;
		private var lightAnimSwitcher:int = 0;
		
		private var coordinatesFont:FlxBitmapFont;
		private var numbers:Object;
		
		private var shipXCoordN:Number = 0;
		private var cursorXCoordN:Number = 0;
		private var waypointXCoordN:Number = 0;
		private var shipXCoordS:String = "";
		private var cursorXCoordS:String = "";
		private var waypointXCoordS:String = "";
		
		private var shipYCoordN:Number = 0;
		private var cursorYCoordN:Number = 0;
		private var waypointYCoordN:Number = 0;
		private var shipYCoordS:String = "";
		private var cursorYCoordS:String = "";
		private var waypointYCoordS:String = "";
		
		private var xDP1:int = 3;
		private var yDP1:int = 3;
		
		private var xDP2:int = 3;
		private var yDP2:int = 3;
		
		private var xDP3:int = 3;
		private var yDP3:int = 3;
		
		private var helperSprite:FlxSprite;
		
		public function StarmapHUD(X:Number=0, Y:Number=0, top:Boolean = true) 
		{
			super(X, Y)
			this.top = top;
			if(top){
				loadGraphic(graphicAssets.STARMAP_HUD_TOP);
				lights = new Array(6);
				for (var i:int = 0; i < 6; i++) {
					//see GalaxyHUD.as for explanation
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
				
				spinningIcon = new FlxSprite(454, 4);
				spinningIcon.loadGraphic(graphicAssets.GHUD_ICON, true, false, 14, 17);
				spinningIcon.addAnimation("sitStill", [0], 0, false);
				spinningIcon.addAnimation("spin", [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 0], 30, false);
				spinningIcon.play("spin");
				spinningIcon.scrollFactor.x = spinningIcon.scrollFactor.y = 0;
			}else {
				loadGraphic(graphicAssets.STARMAP_HUD_BOT);
				lights = new Array(6);
				for (var i:int = 0; i < 6; i++) {
					//see GalaxyHUD.as for explanation
					lights[i] = new FlxSprite((8*(i%2))+298 + x, (Math.floor(i/2) * 7) + 13 + y);
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
				
				spinningIcon = new FlxSprite(454, 459);
				spinningIcon.loadGraphic(graphicAssets.GHUD_ICON, true, false, 14, 17);
				spinningIcon.addAnimation("sitStill", [0], 0, false);
				spinningIcon.addAnimation("spin", [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 0], 30, false);
				spinningIcon.play("spin");
				spinningIcon.scrollFactor.x = spinningIcon.scrollFactor.y = 0;
			}
			
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
				}
				if ((lights[i] as FlxSprite).finished && lightDelays[i] <= 0) {
					(lights[i] as FlxSprite).play(randomLightAnim());
					lightDelays[i] = (FlxG.random() * 5);
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
		public function updateCoords(shipCoordsX:Number, shipCoordsY:Number, cursorCoordsX:Number, cursorCoordsY:Number, waypointCoordsX:Number = NaN, waypointCoordsY:Number = NaN):void {
			shipXCoordN = shipCoordsX;
			shipYCoordN = shipCoordsY;
			cursorXCoordN = cursorCoordsX;
			cursorYCoordN = cursorCoordsY;
			waypointXCoordN = waypointCoordsX;
			waypointYCoordN = waypointCoordsY;
			shipXCoordS = "" + shipCoordsX;
			shipYCoordS = "" + shipCoordsY;
			cursorXCoordS = "" + cursorCoordsX;
			cursorYCoordS = "" + cursorCoordsY;
			waypointXCoordS = isNaN(waypointXCoordN) ? "" : "" + waypointCoordsX;
			waypointYCoordS = isNaN(waypointXCoordN) ? "" : "" + waypointCoordsY;
			
			if (shipXCoordN >= 100)
				xDP1 = 3;
			if (shipXCoordN >= 10 && shipXCoordN < 100)
				xDP1 = 2;
			if (shipXCoordN >= 0 && shipXCoordN < 10)
				xDP1 = 1;
			if (shipYCoordN >= 100)
				yDP1 = 3;
			if (shipYCoordN >= 10 && shipYCoordN < 100)
				yDP1 = 2;
			if (shipYCoordN >= 0 && shipYCoordN < 10)
				yDP1 = 1;
				
			if (cursorXCoordN >= 100)
				xDP2 = 3;
			if (cursorXCoordN >= 10 && cursorXCoordN < 100)
				xDP2 = 2;
			if (cursorXCoordN >= 0 && cursorXCoordN < 10)
				xDP2 = 1;
			if (cursorYCoordN >= 100)
				yDP2 = 3;
			if (cursorYCoordN >= 10 && cursorYCoordN < 100)
				yDP2 = 2;
			if (cursorYCoordN >= 0 && cursorYCoordN < 10)
				yDP2 = 1;
				
			if (!isNaN(waypointXCoordN)){
				if (waypointXCoordN >= 100)
					xDP3 = 3;
				if (waypointXCoordN >= 10 && waypointXCoordN < 100)
					xDP3 = 2;
				if (waypointXCoordN >= 0 && waypointXCoordN < 10)
					xDP3 = 1;
				if (waypointYCoordN >= 100)
					yDP3 = 3;
				if (waypointYCoordN >= 10 && waypointYCoordN < 100)
					yDP3 = 2;
				if (waypointYCoordN >= 0 && waypointYCoordN < 10)
					yDP3 = 1;
			}
				
			if (shipXCoordN % 1 == 0)
				shipXCoordS += ".0"
			if (shipYCoordN % 1 == 0)
				shipYCoordS += ".0";
				
			if (cursorXCoordN % 1 == 0)
				cursorXCoordS += ".0"
			if (cursorYCoordN % 1 == 0)
				cursorYCoordS += ".0";	
				
			if (!isNaN(waypointXCoordN)){
				if (waypointXCoordN % 1 == 0)
					waypointXCoordS += ".0"
				if (waypointYCoordN % 1 == 0)
					waypointYCoordS += ".0";
			}
		}
		private function drawCoords():void {
			
			//Ship - Waypoint - Cursor
			
			//Draw coordinate set one. Ship coordinates.
			//X
			for (var i:int = 0; i < shipXCoordS.length; i++) {
				if (i > xDP1+1)
					break;
				helperSprite = numbers[shipXCoordS.charAt(i)];
				if (i == xDP1+1)
					helperSprite.x = ((12 * (i + (3 - xDP1))) + 65) - 8;
				else
					helperSprite.x = (12 * (i + (3 - xDP1))) + 65;
				helperSprite.y = top ? 6 : 450;
				helperSprite.color = 0x7FC0EB;
				helperSprite.draw();
			}
			//Y
			for (i = 0; i < shipYCoordS.length; i++) {
				if (i > yDP1+1)
					break;
				helperSprite = numbers[shipYCoordS.charAt(i)];
				if (i == yDP1+1)
					helperSprite.x = ((12 * (i + (3 - yDP1))) + 65) - 8;
				else
					helperSprite.x = (12 * (i + (3 - yDP1))) + 65;
				helperSprite.y = top ? 19 : 463;
				helperSprite.color = 0x7FC0EB;
				helperSprite.draw();
			}
			
			//Draw coordinate set two. Waypoint coordinates.
			//X
			if(!isNaN(waypointXCoordN)){
				for (i = 0; i < waypointXCoordS.length; i++) {
					if (i > xDP3+1)
						break;
					helperSprite = numbers[waypointXCoordS.charAt(i)];
					if (i == xDP3+1)
						helperSprite.x = ((12 * (i + (3 - xDP3))) + 242) - 8;
					else
						helperSprite.x = (12 * (i + (3 - xDP3))) + 242;
					helperSprite.y = top ? 6 : 450;
					helperSprite.color = 0x7FC0EB;
					helperSprite.draw();
				}
				//Y
				for (i = 0; i < waypointYCoordS.length; i++) {
					if (i > yDP3+1)
						break;
					helperSprite = numbers[waypointYCoordS.charAt(i)];
					if (i == yDP3+1)
						helperSprite.x = ((12 * (i + (3 - yDP3))) + 242) - 8;
					else
						helperSprite.x = (12 * (i + (3 - yDP3))) + 242;
					helperSprite.y = top ? 19 : 463;
					helperSprite.color = 0x7FC0EB;
					helperSprite.draw();
				}
			}
			//Draw coordinate set three. Cursor coordinates.
			//X
			for (i = 0; i < cursorXCoordS.length; i++) {
				if (i > xDP2+1)
					break;
				helperSprite = numbers[cursorXCoordS.charAt(i)];
				if (i == xDP2+1)
					helperSprite.x = ((12 * (i + (3 - xDP2))) + 397) - 8;
				else
					helperSprite.x = (12 * (i + (3 - xDP2))) + 397;
				helperSprite.y = top ? 6 : 450;
				helperSprite.color = 0x7FC0EB;
				helperSprite.draw();
			}
			//Y
			for (i = 0; i < cursorYCoordS.length; i++) {
				if (i > yDP2+1)
					break;
				helperSprite = numbers[cursorYCoordS.charAt(i)];
				if (i == yDP2+1)
					helperSprite.x = ((12 * (i + (3 - yDP2))) + 397) - 8;
				else
					helperSprite.x = (12 * (i + (3 - yDP2))) + 397;
				helperSprite.y = top ? 19 : 463;
				helperSprite.color = 0x7FC0EB;
				helperSprite.draw();
			}
		}
	}
}