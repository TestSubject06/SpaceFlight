package states
{
	import assets.graphicAssets;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import objects.screenStuff.GalaxyHUD;
	import objects.solarSystemObjects.Planet;
	import objects.solarSystemObjects.redSun;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import effects.StarfieldFX;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SolarSystem extends ManagedState 
	{
		protected var planetsGroup:FlxGroup = new FlxGroup();
		protected var shipsGroup:FlxGroup = new FlxGroup();
		protected var uiGroup:FlxGroup = new FlxGroup();
		protected var coordinates:FlxPoint = new FlxPoint(0, 0);
		protected var solarID:uint = 0;
		protected var sunType:String;
		protected var stars:StarfieldFX;
		protected var starField1:FlxSprite;
		private var minimap:FlxSprite;
		private var minimapPlayerDot:FlxSprite;
		private var timer:Number = 0;
		private var randomAngle2:Number = 0;
		private var orbitPlanet:Planet;
		private var time:Number = 0;
		private var galaxyHud:GalaxyHUD;
		private var globalCoordX:Number;
		private var globalCoordY:Number;
		private var solarSeed:Number;
		private var exitID:int;
		private var closestPlanet:FlxSprite;
		public function SolarSystem(SolarSeed:Number, EntryID:int):void {
			solarSeed = SolarSeed;
			exitID = EntryID;
		}
		override public function create():void 
		{
			super.create();
			passDraw = false;
			passUpdate = false;
			
			//Generate based on solar seed.
			FlxG.globalSeed = solarSeed;
			//TODO: Broaden the possible results here
			if (FlxG.random() >= 0) {
				sunType = "red";
			}
			for (var i:int = 1; i <= 7; i++) {
				if (FlxG.random() > 0.6) {
					planetsGroup.add(new Planet(getPlanetType(i), i, FlxG.random()*8000));
				}
			}
			
			stars = new StarfieldFX;
			starField1 = stars.create(0, 0, FlxG.width, FlxG.height, 50, 1, 20);
			starField1.scrollFactor.x = starField1.scrollFactor.y = 0;
			stars.setStarSpeed(0, 0);
			stars.start(0);
			stars.starFieldType = StarfieldFX.STARFIELD_TYPE_2D;
			stars.setBackgroundColor(0x0);
			add(starField1);
			
			
			shipsGroup.add(Registry.playerShip);
			FlxG.camera.follow(Registry.playerShip);
			
			createStar();
			randomizePlanets();
			randomizeEntry();
			createMap();
			
			galaxyHud = new GalaxyHUD(0, 0);
			uiGroup.add(galaxyHud);
			FlxG.log(Registry.stars.members[Registry.exitStar].x + ", " + Registry.stars.members[Registry.exitStar].y);
			FlxG.log(Registry.exitStar);
			globalCoordX = (Registry.stars.members[Registry.exitStar].x + 40000) / 100;
			globalCoordY = (Registry.stars.members[Registry.exitStar].y + 40000) / 100;
			galaxyHud.updateCoords(400, 400);
			
			add(planetsGroup);
			add(shipsGroup);
			add(uiGroup);
			FlxG.worldBounds = new FlxRect(0, 0, 10000, 6000);
			getClosestPlanet();
			
			FlxG.watch(Registry.playerShip, "velocity", "V");
			FlxG.watch(Registry.playerShip, "acceleration", "A");
		}
		private function getPlanetType(orbit:int):String {
			var chance:Number = FlxG.random();
			switch(orbit) {
				//Close orbit. Rocks and tinies only, MAYBE a water.
				case 1:
					if (chance >= 0) {
						return "rock";
					}else {
						return "rock";
					}
				case 2:
					if (chance >= 0) {
						return "rock";
					}else {
						return "rock";
					}
				//Mid orbit, best chance for everything, really
				case 3:
					if (chance <= .3) {
						return "rock";
					}else if (chance <= 0.6) {
						return "water";
					}else {
						return "water2";
					}
				case 4:
					if (chance <= .3) {
						return "rock";
					}else if (chance <= 0.6) {
						return "water";
					}else {
						return "water2";
					}
				case 5:
					if (chance <= .3) {
						return "rock";
					}else if (chance <= 0.6) {
						return "water";
					}else {
						return "water2";
					}
				//Far orbit, tinies, rocks, ice
				case 6:
					if (chance <= .3) {
						return "rock";
					}else if (chance <= 0.6) {
						return "ice";
					}else {
						return "ice";
					}
				case 7:
					if (chance <= .3) {
						return "rock";
					}else if (chance <= 0.6) {
						return "ice";
					}else {
						return "ice";
					}
			}
			//If all else fails, return a goddamned rock.
			return "rock";
		}
		override public function update():void 
		{
			time += FlxG.elapsed;
			Registry.controlPlayer();
			stars.setStarSpeed( -Registry.playerShip.velocity.x / 300, -Registry.playerShip.velocity.y / 300);
			timer += FlxG.elapsed;
			if (timer > .3) {
				minimapPlayerDot.visible = !minimapPlayerDot.visible;
				getClosestPlanet();
				timer = 0;
			}
			//<schonstal> 1. Find the angle between them with FlxU.getAngle on the player position and planet position
			//<schonstal> 2. getAngle returns degrees for some reason so you'll have to convert it to radians: angle*Math.PI/180
			//<schonstal> 3. find the normalized direction vector: y = sin(angle), x = cos(angle)
			//<schonstal> 4. set acceleration.y to distance * constant speed * direction.y, and do the same for x
			var planetDistance:Number = FlxU.getDistance(Registry.playerShip.getMidpoint(), closestPlanet.getMidpoint());
			//FlxG.log(planetDistance);
			if(planetDistance < 500) {
				var angle:Number = Math.atan2(closestPlanet.getMidpoint().y - Registry.playerShip.getMidpoint().y, closestPlanet.getMidpoint().x - Registry.playerShip.getMidpoint().x);
				var direction:Point = new Point(Math.cos(angle), Math.sin(angle));
				var accel:Point = new Point(300 * direction.x, 300 * direction.y);
				Registry.playerShip.acceleration.x += accel.x;
				Registry.playerShip.acceleration.y += accel.y;
			}
			minimapPlayerDot.x = (Registry.playerShip.x / 10000) * 140 - 1 + minimap.x+6;
			minimapPlayerDot.y = Registry.playerShip.y / 6000 * 90 - 1 + minimap.y + 37;
			super.update();
			if (Registry.playerShip.x < -300 || Registry.playerShip.x > 10300 || Registry.playerShip.y < -300 || Registry.playerShip.y > 6300) {
				StateManager.masterState.popState();
			}
			if (FlxG.keys.justPressed("O")) {
				initiateOrbit();
				
			}
			if (FlxG.keys.justPressed("L")) {
				var blah:FlxSprite = new FlxSprite(FlxG.camera.scroll.x, FlxG.camera.scroll.y)
				blah.pixels = generateLandingMap(orbitPlanet)
				add(blah);
			}
			if (orbitPlanet != null) {
				Registry.playerShip.x = ((Math.cos(time) * 100) + orbitPlanet.x) + (orbitPlanet.width / 2);
				Registry.playerShip.y = ((Math.sin(time) * 100) + orbitPlanet.y) + (orbitPlanet.height / 2);
				Registry.playerShip.angle = FlxU.getAngle(Registry.playerShip.getMidpoint(), orbitPlanet.getMidpoint()) - 180;
			}
			if (FlxG.keys.justPressed("ENTER")) {
				StateManager.masterState.addState(new Menu1());
				stars.stop();
			}
		}
		override public function draw():void 
		{
			stars.draw();
			super.draw();
		}
		private function getClosestPlanet():void {
			for(var i:int = 0; i < planetsGroup.length; i++) {
				if (planetsGroup.members[i] is redSun) {
					continue;
				}
				if (closestPlanet == null){
					closestPlanet = planetsGroup.members[i];
				}
				if (FlxU.getDistance(Registry.playerShip.getMidpoint(), planetsGroup.members[i].getMidpoint()) < FlxU.getDistance(Registry.playerShip.getMidpoint(), closestPlanet.getMidpoint())) {
					closestPlanet = planetsGroup.members[i];
				}
			}
		}
		private function initiateOrbit():void {
			orbitPlanet = null;
			FlxG.overlap(Registry.playerShip, planetsGroup, setOrbitPlanet);
			FlxG.log(orbitPlanet);
			if (orbitPlanet) {
				FlxG.camera.follow(orbitPlanet);
			}else {
				FlxG.camera.follow(Registry.playerShip);
			}
		}
		private function setOrbitPlanet(object1:FlxObject, object2:FlxObject):void {
			orbitPlanet = (object1 is Planet) ? Planet(object1) : Planet(object2);
		}
		private function createStar():void {
			switch(sunType) {
				case "red":
					var redsun:redSun;
					redsun = new redSun();
					for (var i:int = 0; i < redsun.members.length; i++) {
						(redsun.members[i] as FlxSprite).x = 5000 - ((redsun.members[i] as FlxSprite).width / 2);
						(redsun.members[i] as FlxSprite).y = 3000 - ((redsun.members[i] as FlxSprite).height / 2);
					}
					planetsGroup.add(redsun);
				break;
			}
		}
		
		//TODO: Fix the top corner of the map
		private function generateLandingMap(thePlanet:Planet):BitmapData {
			var theBMD:BitmapData = new BitmapData(200, 200, true, 0x0);
			theBMD.perlinNoise(200, 200, 25, thePlanet.perlinSeed, true, true, 1);
			thePlanet.perlinSeed = Math.random() * 521354321;
			
			var tmp1:int = 0;
			var tmp2:int = 0;
			for (var i:int = 0; i < 200; i++) {
				for (var k:int = 0; k < 200; k++) {
					tmp1 = theBMD.getPixel(i, k) >> 16;
					if (tmp1 < 255) {
						theBMD.setPixel(i, k, 0xFFFFFF);
					}
					if (tmp1 < 180) {
						theBMD.setPixel(i, k, 0xC3CBD0);
					}
					if (tmp1 < 170) {
						theBMD.setPixel(i, k, 0x653F25);
					}
					if (tmp1 < 160) {
						theBMD.setPixel(i, k, 0x855432);
					}
					if (tmp1 < 155) {
						theBMD.setPixel(i, k, 0x28741B);
					}
					if (tmp1 < 135) {
						theBMD.setPixel(i, k, 0x3DAE29);
					}
					if (tmp1 < 130) {
						theBMD.setPixel(i, k, 0x96CC33);
					}
					if (tmp1 < 125) {
						theBMD.setPixel(i, k, 0xD3C89C);
					}
					if (tmp1 < 120) {
						theBMD.setPixel(i, k, 0x0000FF);
					}
					if (tmp1 < 115) {
						theBMD.setPixel(i, k, 0x000099);
					}
					if (tmp1 < 110) {
						theBMD.setPixel(i, k, 0x000066);
					}
					if (tmp1 < 105) {
						theBMD.setPixel(i, k, 0x000033);
					}
				}
			}
			return theBMD;
		}
		private function randomizePlanets():void {
			for (var i:int = 0; i < planetsGroup.members.length; i++) {
				if (planetsGroup.members[i] is Planet) {
					var randomAngle:Number = Math.random() * 360;
					(planetsGroup.members[i] as Planet).x = Math.cos(FlxMath.asRadians(randomAngle)) * ((planetsGroup.members[i] as Planet).orbit * (5000/7)) + 5000;
					(planetsGroup.members[i] as Planet).y = Math.sin(FlxMath.asRadians(randomAngle)) * ((planetsGroup.members[i] as Planet).orbit * (3000 / 7)) + 3000;
					for (var k:int = 0; k < planetsGroup.members.length; k++) {
						if(planetsGroup.members[k] is redSun){
							(planetsGroup.members[i] as Planet).angle = FlxVelocity.angleBetween(planetsGroup.members[i], (planetsGroup.members[k] as FlxGroup).members[0] as FlxSprite, true);
						}
					}
				}
			}
		}
		private function randomizeEntry():void {
			var chance:int = Math.floor(Math.random() * 4);
			switch(chance) {
				case 0:
					Registry.playerShip.x = Math.random() * 10000;
					Registry.playerShip.y = 0;
				break;
				case 1:
					Registry.playerShip.x = Math.random() * 10000;
					Registry.playerShip.y = 6000;
				break;
				case 2:
					Registry.playerShip.x = 0;
					Registry.playerShip.y = Math.random() * 6000;
				break;
				case 3:
					Registry.playerShip.x = 10000;
					Registry.playerShip.y = Math.random() * 6000;
				break;
			}
		}
		private function createMap():void {
			minimap = new FlxSprite(FlxG.width - 152, 25, graphicAssets.SOLARMAP_GFX);
			uiGroup.add(minimap);
			var orbit:FlxSprite = new FlxSprite(minimap.x + 1, minimap.y + 32).makeGraphic(150, 100, 0x00);
			orbit.pixels = new BitmapData(150, 100, true, 0x0);
			uiGroup.add(orbit);
			var tempDot:FlxSprite;
			for (var i:int = 0; i < planetsGroup.members.length; i++) {
				if(planetsGroup.members[i] is redSun){
					uiGroup.add(new FlxSprite((((planetsGroup.members[i] as FlxGroup).members[0] as FlxSprite).x / 10000 * 140 - 0)+orbit.x+5, (((planetsGroup.members[i] as FlxGroup).members[0] as FlxSprite).y / 6000 * 90 - 0)+orbit.y+5).makeGraphic(4, 4, 0xFFFF0000));
				}
				if (planetsGroup.members[i] is Planet) {
					var lastpos:FlxPoint = new FlxPoint((Math.cos(FlxMath.asRadians(0)) * ((planetsGroup.members[i] as Planet).orbit*10)) + 75, (Math.sin(FlxMath.asRadians(0)) * ((planetsGroup.members[i] as Planet).orbit*6.5)) + 50);
					for (var k:int = 0; k < 361; k++) {
						orbit.drawLine(lastpos.x, lastpos.y, (Math.cos(FlxMath.asRadians(k)) * ((planetsGroup.members[i] as Planet).orbit*10)) + 75, (Math.sin(FlxMath.asRadians(k)) * ((planetsGroup.members[i] as Planet).orbit*6.5)) + 50, 0xFFFFFFFF, 1);
						lastpos.x = (Math.cos(FlxMath.asRadians(k)) * ((planetsGroup.members[i] as Planet).orbit*10)) + 75;
						lastpos.y = (Math.sin(FlxMath.asRadians(k)) * ((planetsGroup.members[i] as Planet).orbit*6.5)) + 50;
					}
					tempDot = (uiGroup.add(new FlxSprite(((planetsGroup.members[i] as FlxSprite).x / 10000 * 140 - 1) + orbit.x + 5, ((planetsGroup.members[i] as FlxSprite).y / 6000 * 90 - 1) + orbit.y + 5)) as FlxSprite);
					switch((planetsGroup.members[i] as Planet).type) {
						case "rock":							
							tempDot.makeGraphic(3, 3, 0xFFFF00FF);
						break;
						case "ice":
							tempDot.makeGraphic(3, 3, 0xFF00CCFF);
						break;
						case "water":
							tempDot.makeGraphic(3, 3, 0xFF0000FF);	
						break;
						case "water2":
							tempDot.makeGraphic(3, 3, 0xFF0000FF);		
						break;
					}
				}
			}
			minimapPlayerDot = new FlxSprite(0, 0, null).makeGraphic(2, 2, 0xFFFFFFFF);
			uiGroup.add(minimapPlayerDot);
			uiGroup.setAll("scrollFactor", new FlxPoint(0, 0), true);
		}
		override public function destroy():void 
		{
			FlxG.resetInput();
			FlxG.camera.follow(Registry.playerShip, FlxCamera.STYLE_LOCKON);
			FlxG.camera.bounds = null;
			FlxSpecialFX.clear();
			shipsGroup.remove(Registry.playerShip, true);
			Registry.angle = Registry.playerShip.angle;
			Registry.exitStar = exitID;
			super.destroy();
		}
		override public function recoverControl():void 
		{
			super.recoverControl();
			stars.start(0);
		}
	}
}