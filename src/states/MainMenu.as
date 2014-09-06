package states 
{
	import assets.graphicAssets;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import objects.galaxy.Flux;
	import objects.galaxy.Nebula;
	import solarSystems.SolarStar;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*
	import solarSystems.SolarSystemLookup;
	import objects.screenStuff.GalaxyHUD;
	import effects.StarfieldFX;
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class MainMenu extends ManagedState
	{
		private var stars:StarfieldFX;
		private var stars2:StarfieldFX;
		private var stars3:StarfieldFX;
		private var stars4:StarfieldFX;
		private var starField1:FlxSprite;
		private var starField2:FlxSprite;
		private var starField3:FlxSprite;
		private var starField4:FlxSprite;
		private var galaxyHUD:GalaxyHUD;
		private var globalCoordX:Number;
		private var globalCoordY:Number;
		private var SolarSystemsGroup:FlxGroup = new FlxGroup();
		private var entryID:uint;
		
		//Flux teleportation network
		private var fluxLaunch:Boolean = false;
		private var fluxExit:Flux;
		
		private var file:FileReference = new FileReference();
		
		override public function create():void 
		{
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			stars = new StarfieldFX;
			starField1 = stars.create(0, 0, FlxG.width+50, FlxG.height+50, 150, 1, 20);
			starField1.scrollFactor.x = starField1.scrollFactor.y = 0;
			starField1.x = starField1.y = -25;
			stars.setStarSpeed(0, 0);
			stars.setBackgroundColor(0x00);
			stars.start(0);
			add(starField1);
			
			stars2 = new StarfieldFX;
			starField2 = stars2.create(0, 0, FlxG.width, FlxG.height, 25, 1, 20);
			starField2.scrollFactor.x = starField2.scrollFactor.y = 0;
			starField2.x = starField2.y = -25;
			stars2.setStarSpeed(0, 0);
			stars2.setStarDepthColors(5, 0xff581111, 0xffF41111);
			stars2.setBackgroundColor(0x00);
			stars2.start(0);
			add(starField2);
			
			stars3 = new StarfieldFX;
			starField3 = stars3.create(0, 0, FlxG.width, FlxG.height, 25, 1, 20);
			starField3.scrollFactor.x = starField3.scrollFactor.y = 0;
			starField3.x = starField3.y = -25;
			stars3.setStarSpeed(0, 0);
			stars3.setStarDepthColors(5, 0xff115811, 0xff11F411);
			stars3.setBackgroundColor(0x00);
			stars3.start(0);
			add(starField3);
			
			stars4 = new StarfieldFX;
			starField4 = stars4.create(0, 0, FlxG.width, FlxG.height, 25, 1, 20);
			starField4.scrollFactor.x = starField4.scrollFactor.y = 0;
			starField4.x = starField4.y = -25;
			stars4.setStarSpeed(0, 0);
			stars4.setStarDepthColors(5, 0xff333358, 0xff3333F4);
			stars4.setBackgroundColor(0x00);
			stars4.start(0);
			add(starField4);
			
			//Time to generate the Nebulae
			generateNebulae();
			
			Registry.playerShip = new FlxSprite(FlxG.width/2-10, FlxG.height / 2 - 10);
			Registry.playerShip.loadGraphic(graphicAssets.SHIP_TEST, true, false, 35, 25);
			Registry.playerShip.addAnimation("normal", [0]);
			Registry.playerShip.addAnimation("distort", [0, 1, 0, 2, 0, 3, 0, 1, 2, 0, 2, 3, 0, 1, 2, 3, 0, 2, 0, 3, 0, 2, 1, 2, 0, 3, 0, 1, 2], 30);
			Registry.playerShip.maxVelocity.x = Registry.playerShip.maxVelocity.y = 500;
			Registry.playerShip.angle = Registry.angle;
			Registry.playerShip.antialiasing = true;
			Registry.playerShip.play("normal");
			Registry.starmapGalaxyCoords = new FlxPoint(0, 0);
			
			FlxG.camera.follow(Registry.playerShip);
			
			galaxyHUD = new GalaxyHUD(0, 0);
			
			add(SolarSystemsGroup);
			
			FlxG.globalSeed = 0x29823896;
			
			SolarSystemsGroup.add(new SolarStar(0, 0, 0, FlxG.random()));
			Registry.stars = SolarSystemsGroup;
			
			Registry.fluxes = new FlxGroup();
			//First pair
			var dumb:Flux = new Flux(70, 70);
			var dumb2:Flux = new Flux(2000, -1500);
			dumb.sisterFlux = dumb2;
			dumb2.sisterFlux = dumb;
			Registry.fluxes.add(dumb);
			Registry.fluxes.add(dumb2);
			//Second set
			dumb = new Flux( -70, -70);
			dumb2 = new Flux( -24000, 14400);
			dumb.sisterFlux = dumb2;
			dumb2.sisterFlux = dumb;
			Registry.fluxes.add(dumb);
			Registry.fluxes.add(dumb2);
			
			add(Registry.fluxes);
			
			add(Registry.playerShip);
			add(galaxyHUD);
			
			super.create();
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, takeScreenshot);
		}
		private function takeScreenshot(kb:KeyboardEvent):void {
			if (kb.keyCode == 123) {
				file.save(PNGEncoder.encode(FlxG.camera.buffer), "SpaceFlight.png");
			}
		}
		private function generateNebulae():void {
			add(new Nebula(500, 500, 100, 100, 4));
		}
		override public function update():void 
		{
			FlxG.worldBounds.make(FlxG.camera.scroll.x - 700, FlxG.camera.scroll.y - 700, FlxG.width + 700, FlxG.height +700);
			if(!fluxLaunch){
				Registry.controlPlayer();
			}
			Registry.starmapGalaxyCoords.x = Registry.playerShip.x;
			Registry.starmapGalaxyCoords.y = Registry.playerShip.y;
			
			super.update();
			if(!fluxLaunch){
				FlxG.overlap(Registry.playerShip, Registry.fluxes, launchPlayer);
			}else {
				if (FlxU.getDistance(Registry.playerShip.getMidpoint(), fluxExit.getMidpoint()) < fluxExit.sisterDistance/4) {
					Registry.normalizePlayerDirection(2000);
				}else if (FlxU.getDistance(Registry.playerShip.getMidpoint(), fluxExit.getMidpoint()) < fluxExit.sisterDistance/2) {
					Registry.normalizePlayerDirection(4000);
				}
				
				FlxG.overlap(Registry.playerShip, fluxExit, recoverPlayer);
			}
			
			stars.setStarSpeed(  -Registry.playerShip.velocity.x / 300, -Registry.playerShip.velocity.y / 300);
			stars2.setStarSpeed( -Registry.playerShip.velocity.x / 300, -Registry.playerShip.velocity.y / 300);
			stars3.setStarSpeed( -Registry.playerShip.velocity.x / 300, -Registry.playerShip.velocity.y / 300);
			stars4.setStarSpeed( -Registry.playerShip.velocity.x / 300, -Registry.playerShip.velocity.y / 300);
			
			if (Registry.playerShip.x < -39999){
				Registry.playerShip.x = -39999;
				Registry.playerShip.velocity.x = 0;
			}
			if (Registry.playerShip.x > 39999){
				Registry.playerShip.x = 39999;
				Registry.playerShip.velocity.x = 0;
			}
			if (Registry.playerShip.y < -39999){
				Registry.playerShip.y = -39999;
				Registry.playerShip.velocity.y = 0;
			}
			if (Registry.playerShip.y > 39999){
				Registry.playerShip.y = 39999;
				Registry.playerShip.velocity.y = 0;
			}
			
			if (FlxG.keys.justPressed("X") && FlxG.overlap(Registry.playerShip, SolarSystemsGroup, setID)) {
				enterSolarSystem();
			}
			
			if (FlxG.keys.justPressed("ENTER")) {
				StateManager.masterState.addState(new Menu1());
				Registry.starfieldsReady = false;
				stars.stop();
				stars2.stop();
				stars3.stop();
				stars4.stop();
				Registry.exitStar = -1;
			}
			if (Registry.starfieldsReady) {
				stars.start(0);
				stars2.start(0);
				stars3.start(0);
				stars4.start(0);
			}
			if (FlxG.keys.Z) {
				FlxG.timeScale = 0.05;
			}else {
				FlxG.timeScale = 1;
			}
			
			//Galaxy coordinates to the HUD.
			//Global X coordinate.
			//Scale: Every 100 units is 1 on the coordinate system. One decimal place. EG: 235.7 = ~23570x
			//starting at -40000 and ending at 40000
			globalCoordX = (Registry.playerShip.x + 40000) / 100;
			globalCoordY = (Registry.playerShip.y + 40000) / 100;
			galaxyHUD.updateCoords(globalCoordX, globalCoordY);
			
		}
		override public function draw():void 
		{
			stars.draw();
			stars2.draw();
			stars3.draw();
			stars4.draw();
			super.draw();
		}
		private function launchPlayer(object1:FlxSprite, object2:Flux):void {
			if(!object2.fluxCooldown){
				//Revoke player control
				FlxG.flash(0xffffffff, .1);
				//Lock camera
				//FlxG.camera.follow(null);
				//Blast player off (Let the flux handle the firing, since it has a target)
				object2.launchPlayer(Registry.playerShip);
				//Tell the state that the player is being launched.
				fluxLaunch = true;
				fluxExit = object2.sisterFlux;
				Registry.playerShip.play("distort");
				stars.starFieldType = StarfieldFX.STARFIELD_TYPE_2D_STREAK;
				stars2.starFieldType = StarfieldFX.STARFIELD_TYPE_2D_STREAK;
				stars3.starFieldType = StarfieldFX.STARFIELD_TYPE_2D_STREAK;
				stars4.starFieldType = StarfieldFX.STARFIELD_TYPE_2D_STREAK;
			}
		}
		private function recoverPlayer(object1:FlxSprite, object2:Flux):void {
			if(fluxLaunch){
				FlxG.log("Piss");
				FlxG.flash(0xffffffff, .1);
				fluxLaunch = false;
				object2.fluxCooldown = true;
				object1.velocity.make(object1.velocity.x / 15, object1.velocity.y / 15);
				object1.maxVelocity.make(500, 500);
				Registry.playerShip.play("normal");
				stars.starFieldType = StarfieldFX.STARFIELD_TYPE_2D;
				stars2.starFieldType = StarfieldFX.STARFIELD_TYPE_2D;
				stars3.starFieldType = StarfieldFX.STARFIELD_TYPE_2D;
				stars4.starFieldType = StarfieldFX.STARFIELD_TYPE_2D;
			}
		}
		override public function destroy():void 
		{
			FlxSpecialFX.clear();
			remove(Registry.playerShip);
			Registry.angle = Registry.playerShip.angle;
			super.destroy();
		}
		
		private function enterSolarSystem():void {
			Registry.exitStar = entryID;
			stars.active = false;
			stars2.active = false;
			stars3.active = false;
			stars4.active = false;
			FlxSpecialFX.clear();
			StateManager.masterState.addState(new SolarSystem(Registry.stars.members[entryID].seed, entryID));
		}
		
		private function setID(object1:FlxBasic, object2:FlxBasic):void {
			(object1 is SolarStar) ? entryID = (object1 as SolarStar).solarID : entryID = (object2 as SolarStar).solarID;
		}
		
		private function moveShip(lastStar:int):void {
			for (var i:int = 0; i < SolarSystemsGroup.length; i++) {
				if (SolarSystemsGroup.members[i].solarID == lastStar) {
					Registry.playerShip.x = SolarSystemsGroup.members[i].x+8;
					Registry.playerShip.y = SolarSystemsGroup.members[i].y+8;
				}
			}
		}
		override public function recoverControl():void 
		{
			if(Registry.exitStar != -1){
				moveShip(Registry.exitStar);
				Registry.playerShip.velocity.make(0, 0);
			}
			stars.active = true;
			stars2.active = true;
			stars3.active = true;
			stars4.active = true;
			super.recoverControl();
		}
	}
}