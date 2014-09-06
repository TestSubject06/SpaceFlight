package states 
{
	import assets.graphicAssets;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import objects.galaxy.Flux;
	import objects.screenStuff.StarmapHUD;
	import org.flashdevelop.utils.FlashConnect;
	import org.flixel.*;
	import solarSystems.SolarStar;
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Starmap extends ManagedState 
	{
		private var helperRect:Rectangle;
		
		////Things to be in the map base are things that don't change.. like.. ever.
		//Nebulae
		//Stars
		//Flux Connections - These will draw once when they've been discovered.
		private var starmapBase:FlxSprite;
		
		////The rest are objects on top of the map
		//Player indicator
		//Waypoint
		//Player - Waypoint path (This path takes into account nearby discovered fluxes)
		//Fluxes - These animate on the map, so they can't be static.
		//Player Cursor - Arrow Keys / Mouse?
									// If mouse then click/drag to scroll the map.
		private var playerIndicator:FlxSprite;
		private var waypoint:FlxSprite;
		private var fluxes:FlxGroup;
		private var Cursor:FlxSprite;
		private var HUD_Top:StarmapHUD;
		private var HUD_Bot:StarmapHUD;
		private var shipCoordX:Number;
		private var shipCoordY:Number;
		private var waypointPath:Vector.<FlxPoint>;
		private var waypointPathSprite:FlxSprite;
		private var waypointCanvas:BitmapData;
		private var waypointTick:Number;
		//Helper stuff for the waypoint pathing.
		private var left:int;
		private var right:int;
		private var top:int;
		private var bottom:int;
		
		public function Starmap() 
		{
			passDraw = false;
			passUpdate = false;
			helperRect = new Rectangle();
			helperRect.width = 2;
			helperRect.height = 2;
			waypointPath = new Vector.<FlxPoint>();
		}
		override public function create():void 
		{
			super.create();
			
			starmapBase = new FlxSprite();
			//We want the basic map to be cached in memory
			var tmp:BitmapData;

			if(!FlxG.checkBitmapCache("StarmapBase")){
				tmp = FlxG.createBitmap(2000, 2000, 0xFF000000, false, "StarmapBase");
				//Step one: Draw the nebulae
				//no nebulae yet
				var m:Matrix = new Matrix(1, 0, 0, 1, Math.floor((Registry.nebulaLocations[0].x + 40000) / 40), Math.floor((Registry.nebulaLocations[0].y + 40000) / 40));
				tmp.draw(FlxG.getBitmapFromCache("Nebula1"), m);
				
				//Step two: Draw the stars.
				for each(var a:SolarStar in Registry.stars.members) {
					helperRect.x = Math.floor((a.x + 40000) / 40) - 1;
					helperRect.y = Math.floor((a.y + 40000) / 40) - 1;
					tmp.fillRect(helperRect, getColor(a.solarColor));
				}
				//Step three: Draw the flux connections
				//no fluxes yet.
			}
			if(tmp != null)
				starmapBase.pixels = tmp;
			else
				starmapBase.pixels = FlxG.getBitmapFromCache("StarmapBase");
			//Now to setup the overlay objects.
			//HUD
			HUD_Top = new StarmapHUD(0, 0,true);
			HUD_Top.scrollFactor.make(0, 0);
			
			HUD_Bot = new StarmapHUD(0, 446, false);
			HUD_Bot.scrollFactor.make(0, 0);
			HUD_Bot.visible = false;
			HUD_Bot.exists = false;
			
			//Player indicator
			playerIndicator = new FlxSprite(FlxU.floor((Registry.starmapGalaxyCoords.x + 40000) / 40) - 6, FlxU.floor((Registry.starmapGalaxyCoords.y + 40000) / 40) - 6);
			playerIndicator.loadGraphic(graphicAssets.STARMAP_PLAYER, true, false, 12, 12);
			playerIndicator.addAnimation("blink", [0, 1], 4);
			playerIndicator.play("blink");
			
			shipCoordX = (Registry.starmapGalaxyCoords.x + 40000) / 100;
			shipCoordY = (Registry.starmapGalaxyCoords.y + 40000) / 100;
			
			//Cursor
			Cursor = new FlxSprite(playerIndicator.x - 7, playerIndicator.y - 7, graphicAssets.STARMAP_CURSOR);
			
			//Fluxes
			fluxes = new FlxGroup();
			for each(var p:Flux in Registry.fluxes.members) {
				FlxG.log("Yes");
				var tmpSprite:FlxSprite = new FlxSprite(FlxU.floor((p.x + 40000) / 40) - 4, FlxU.floor((p.y + 40000) / 40) - 4)
				if (p.discovered && !p.hasDrawn) {
					starmapBase.drawLine(tmpSprite.x+4, tmpSprite.y+4, FlxU.floor((p.sisterFlux.x + 40000) / 40), FlxU.floor((p.sisterFlux.y + 40000) / 40), 0xFF666666, .5);
					p.hasDrawn = true;
					p.sisterFlux.hasDrawn = true;
				}
				fluxes.add(tmpSprite);
				tmpSprite.loadGraphic(graphicAssets.STARMAP_FLUX, true, false, 8, 8);
				tmpSprite.addAnimation("flux", [0, 1, 2, 3], 10);
				tmpSprite.play("flux");
			}
			
			//Waypoint if it exists
			waypoint = new FlxSprite(0, 0);
			waypoint.loadGraphic(graphicAssets.STARMAP_WAYPT, true, false, 8, 8);
			waypoint.addAnimation("blink", [0, 1], 4);
			waypoint.play("blink");
			if (Registry.starmapWaypoint == null)
				Registry.starmapWaypoint = new FlxPoint(-10, -10);
			waypoint.x = Registry.starmapWaypoint.x;
			waypoint.y = Registry.starmapWaypoint.y;
			waypoint.visible = waypoint.x == -10 ? false : true;
			waypoint.exists = waypoint.x == -10 ? false : true;
			//Waypoint path
			waypointPathSprite = new FlxSprite(0, 0);
			if (waypoint.exists) {
				calcWayPath();
				prepWayPath();
				waypointTick = 0;
				waypointPathSprite.visible = true;
				waypointPathSprite.exists = true;
			}else {
				waypointPathSprite.visible = false;
				waypointPathSprite.exists = false;
			}
			
			FlxG.camera.follow(Cursor);
			FlxG.camera.deadzone = new FlxRect(-10, -10, 660, 500);
			FlxG.camera.setBounds(0, 0, 2000, 2000, true);
			FlxG.camera.scroll.x = playerIndicator.x - 320;
			FlxG.camera.scroll.y = playerIndicator.y - 240;
			
			
			add(starmapBase);
			add(waypointPathSprite);
			add(fluxes);
			add(waypoint);
			add(playerIndicator);
			add(Cursor);
			add(HUD_Top);
			add(HUD_Bot);
		}
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.LEFT) {
				Cursor.x -= FlxG.keys.Z ? 50 * FlxG.elapsed : 200 * FlxG.elapsed;
				if (Cursor.x+13 < 0) {
					Cursor.x = -13;
				}
			}
			if (FlxG.keys.RIGHT) {
				Cursor.x += FlxG.keys.Z ? 50 * FlxG.elapsed : 200 * FlxG.elapsed;
				if (Cursor.x+13 > 2000) {
					Cursor.x = 1987;
				}
			}
			if (FlxG.keys.UP) {
				Cursor.y -= FlxG.keys.Z ? 50 * FlxG.elapsed : 200 * FlxG.elapsed;
				if (Cursor.y+13 < 0) {
					Cursor.y = -13;
				}
			}
			if (FlxG.keys.DOWN) {
				Cursor.y += FlxG.keys.Z ? 50 * FlxG.elapsed : 200 * FlxG.elapsed;
				if (Cursor.y+13 > 2000) {
					Cursor.y = 1987;
				}
			}
			
			if (Cursor.overlapsAt(Cursor.x, Cursor.y, HUD_Top, true, FlxG.camera)) {
				if (HUD_Top.exists && HUD_Top.visible) {
					HUD_Top.exists = false;
					HUD_Top.visible = false;
					HUD_Bot.exists = true;
					HUD_Bot.visible = true;
				}
			}
			if (Cursor.overlapsAt(Cursor.x, Cursor.y, HUD_Bot, true, FlxG.camera)) {
				if (HUD_Bot.exists && HUD_Bot.visible) {
					HUD_Bot.exists = false;
					HUD_Bot.visible = false;
					HUD_Top.exists = true;
					HUD_Top.visible = true;
				}
			}
			
			if (FlxG.keys.justPressed("X")) {
				if (waypoint.exists) {
					waypoint.exists = false;
					waypoint.visible = false;
					waypoint.x = -10;
					waypoint.y = -10;
					Registry.starmapWaypoint.make(waypoint.x, waypoint.y);
				}else {
					waypoint.exists = true;
					waypoint.visible = true;
					waypoint.play("blink", true);
					playerIndicator.play("blink", true);
					waypoint.x = Cursor.x + 9;
					waypoint.y = Cursor.y + 9;
					Registry.starmapWaypoint.make(waypoint.x, waypoint.y);
					calcWayPath();
					prepWayPath();
					waypointTick = 0;
					waypointPathSprite.visible = true;
				}
			}
			
			if (FlxG.keys.justPressed("ESCAPE")) {
				FlxG.resetInput();
				FlxG.camera.follow(Registry.playerShip, FlxCamera.STYLE_LOCKON);
				FlxG.camera.bounds = null;
				//Reset worldbounds, and camera bounds here
				StateManager.masterState.popState();
			}
			
			//If the waypoint exists, then we need to draw ourselves a nice -n- lovely path to it.
			if (waypoint.exists) {
				waypointPathSprite.exists = true;
				waypointTick += FlxG.elapsed;
				if (waypointTick >= .5) {
					waypointTick -= .5;
					waypointPathSprite.visible = !waypointPathSprite.visible;
				}
			}else {
				waypointPathSprite.exists = false;
				waypointPathSprite.visible = false;
			}
			
			if (waypoint.x == -10) {
				HUD_Top.updateCoords(shipCoordX, shipCoordY, ((Cursor.x + 13) * 40) / 100, ((Cursor.y + 13) * 40) / 100);
				HUD_Bot.updateCoords(shipCoordX, shipCoordY, ((Cursor.x + 13) * 40) / 100, ((Cursor.y + 13) * 40) / 100);
			}else{
				HUD_Top.updateCoords(shipCoordX, shipCoordY, ((Cursor.x+13) * 40) / 100, ((Cursor.y+13) * 40) / 100, ((waypoint.x + 4) * 40) / 100, ((waypoint.y + 4) * 40) / 100);
				HUD_Bot.updateCoords(shipCoordX, shipCoordY, ((Cursor.x + 13) * 40) / 100, ((Cursor.y + 13) * 40) / 100, ((waypoint.x + 4) * 40) / 100, ((waypoint.y + 4) * 40) / 100);
			}
		}
		private function calcWayPath():void {
			while(waypointPath.length > 0)
				waypointPath.pop();
			waypointPath.push(new FlxPoint(playerIndicator.x + 6, playerIndicator.y + 6));
			waypointPath.push(new FlxPoint(fluxes.members[0].x + 4, fluxes.members[0].y + 4));
			waypointPath.push(new FlxPoint(waypoint.x + 4, waypoint.y + 4));
		}
		private function prepWayPath():void {
			//We must ready the sprite to accept the path lines.
			left = waypointPath[0].x;
			right = waypointPath[0].x;
			top = waypointPath[0].y;
			bottom = waypointPath[0].y;
			for each(var a:FlxPoint in waypointPath) {
				if (a.x < left)
					left = a.x;
				if (a.x > right)
					right = a.x;
				if (a.y < top)
					top = a.y;
				if (a.y > bottom)
					bottom = a.y;
			}
			waypointPathSprite.x = left;
			waypointPathSprite.y = top;
			right = (right - waypointPathSprite.x) > 0 ? right - waypointPathSprite.x : 1;
			bottom = (bottom - waypointPathSprite.y) > 0 ? bottom - waypointPathSprite.y : 1;
			waypointCanvas = new BitmapData(right, bottom, true, 0x0);
			waypointPathSprite.pixels = waypointCanvas;
			for (var i:int = 0; i < waypointPath.length-1; i++) {
				waypointPathSprite.drawLine(waypointPath[i].x - waypointPathSprite.x, waypointPath[i].y - waypointPathSprite.y, waypointPath[i + 1].x - waypointPathSprite.x, waypointPath[i + 1].y - waypointPathSprite.y, 0xFF2020FF);
			}
		}
		private function getColor(x:uint):uint {
			switch(x) {
				case 0:
					return 0xFFFF0000;
					break;
			}
			return 0xf;
		}
	}
}