package objects.galaxy 
{
	import assets.graphicAssets;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxMath;
	
	/**
	 * This class serves as the main class for the Fluxes. These teleport the player in fantastic fashion.
	 * Needs to monitor both itself and keep a reference to its sister instance(the exit point).
	 * @author Zachary Tarvit
	 */
	public class Flux extends FlxSprite 
	{
		private static const NUM_STARS:uint = 15;
		private static const STAR_TIMER:Number = .05;
		private var _sisterFlux:Flux;
		private var fluxStars:FlxGroup;
		private var helperSprite:FlxSprite;
		private var starTimer:Number;
		private var helperPoint:FlxPoint;
		private var helperPoint2:FlxPoint;
		private var helperNumber:Number;
		public var sisterAngle:Number;
		private var coolTimer:Number;
		public var fluxCooldown:Boolean;
		public var sisterDistance:Number;
		
		//For use in the map system.
		public var discovered:Boolean;
		public var hasDrawn:Boolean;
		
		public function Flux(X:Number=0, Y:Number=0) 
		{
			super(X, Y);
			fluxStars = new FlxGroup;
			makeGraphic(30, 30, 0x0);
			for (var i:int = 0; i < NUM_STARS; i++) {
				var temp:FlxSprite = new FlxSprite(X + 20, Y + 20);
				temp.loadGraphic(graphicAssets.GALAXY_FLUX_STAR, false, false, 3, 3);
				temp.exists = false;
				fluxStars.add(temp);
			}
			starTimer = 0;
			helperPoint = new FlxPoint;
			helperPoint2 = new FlxPoint;
			fluxCooldown = false;
			coolTimer = 3;
			discovered = false;
			hasDrawn = false;
			
			if (Registry.fluxLocations == null) {
				Registry.fluxLocations = new Vector.<Point>();
			}
			Registry.fluxLocations.push(new Point(x, y));
		}
		public function set sisterFlux(sisterFlux:Flux):void {
			this._sisterFlux = sisterFlux;
			sisterAngle = Math.atan2((y + 15) - (_sisterFlux.y + 15), (x + 15) - (_sisterFlux.x + 15));
			sisterDistance = FlxU.getDistance(getMidpoint(), _sisterFlux.getMidpoint());
		}
		public function get sisterFlux():Flux {
			return _sisterFlux;
		}
		public function launchPlayer(player:FlxSprite):void {
			player.x = x + 15 - (player.width/2);
			player.y = y + 15 - (player.height/2);
			player.maxVelocity.make(6000, 6000);
			player.drag.make(0, 0);
			player.acceleration.make(0, 0);
			player.angle = FlxMath.asDegrees(sisterAngle)+180;
			player.velocity.make( -Math.cos(sisterAngle) * 6000, -Math.sin(sisterAngle) * 6000);
			fluxCooldown = true;
			coolTimer = 3;
			discovered = true;
			_sisterFlux.discovered = true;
		}
		override public function update():void 
		{
			if (onScreen()) {
				super.update();
				if(fluxCooldown){
					coolTimer -= FlxG.elapsed;
					if (coolTimer <= 0){
						coolTimer = 3;
						fluxCooldown = false;
					}
				}
				starTimer += FlxG.elapsed;
				if (starTimer > STAR_TIMER) {
					helperSprite = (fluxStars.getFirstAvailable() as FlxSprite);
					if(helperSprite != null){
						starTimer = FlxG.random() * (2 * Math.PI);
						helperSprite.x = (20 * Math.cos(starTimer)) + (x+15);
						helperSprite.y = (20 * Math.sin(starTimer)) + (y+15);
						helperNumber = (FlxG.random() * 30) + 20;
						helperSprite.velocity.make(-(Math.cos(starTimer)*helperNumber), -(Math.sin(starTimer)*helperNumber));
						helperSprite.exists = true;
						starTimer = 0;
					}
				}
				for each(var a:FlxSprite in fluxStars.members) {
					if (a.exists) {
						helperNumber = FlxU.getDistance(helperPoint.make(a.x, a.y), helperPoint2.make(x+15, y+15));
						a.frame = FlxU.floor(helperNumber) / 6.6666;
						if (helperNumber < 1){
							a.exists = false;
						}
					}
				}
				fluxStars.update();
			}else {
				if (fluxCooldown)
					fluxCooldown = false;
			}
		}
		override public function draw():void 
		{
			if(onScreen()){
				super.draw();
				fluxStars.draw();
			}
		}
	}
}