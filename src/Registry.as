package  
{
	import org.flixel.*;
	import flash.geom.Point;
	import org.flixel.plugin.photonstorm.FlxMath;
	/**
	 * ...
	 * @author ...
	 */
	public class Registry 
	{
		public static var angle:Number = 0;
		public static var starfieldsReady:Boolean = true;
		public static var exitStar:int = -1;
		public static var playerShip:FlxSprite;
		public static var stars:FlxGroup;
		public static var starmapWaypoint:FlxPoint;
		public static var starmapGalaxyCoords:FlxPoint;
		public static var nebulaLocations:Vector.<Point>;
		public static var fluxLocations:Vector.<Point>;
		public static var fluxes:FlxGroup;
		
		public static function controlPlayer():void {
			var point:Point = new Point(playerShip.velocity.x, playerShip.velocity.y);
			if (FlxG.keys.UP && point.length < 300) {
				playerShip.acceleration.x = Math.cos(FlxMath.asRadians(playerShip.angle)) * 200;
				playerShip.acceleration.y = Math.sin(FlxMath.asRadians(playerShip.angle)) * 200;
			}else {
				if(point.length > 1){
					point.normalize(point.length - 2);
				}else if(point.x != 0 && point.y != 0){
					point.x = point.y = 0;
				}
				playerShip.acceleration.x = playerShip.acceleration.y = 0;
			}
			if (FlxG.keys.DOWN) {
				point.x *= .95;
				point.y *= .95;
			}
			if (FlxG.keys.LEFT) {
				playerShip.angle -= 3;
			}if (FlxG.keys.RIGHT) {
				playerShip.angle += 3;
			}
			
			if (point.length > 500) {
				point.normalize(500);
			}
			playerShip.velocity.x = point.x;
			playerShip.velocity.y = point.y;
		}
		public static function normalizePlayerDirection(scalar:Number):void {
			var point:Point = new Point(playerShip.velocity.x, playerShip.velocity.y);
			point.normalize(scalar);
			playerShip.velocity.x = point.x;
			playerShip.velocity.y = point.y;
		}
	}
}