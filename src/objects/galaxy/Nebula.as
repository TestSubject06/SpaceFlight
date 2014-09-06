package objects.galaxy 
{
	import adobe.utils.CustomActions;
	import assets.graphicAssets;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Tarvit
	 */
	public class Nebula extends FlxObject 
	{
		private var nebula:FlxTilemap;
		private var sparkles:FlxGroup;
		private var flashes:FlxGroup;
		private var density:int;
		private var firstRun:Boolean;
		public function Nebula(X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0, numCircles:int = 0) 
		{
			super(X, Y, Width, Height);
			sparkles = new FlxGroup();
			flashes = new FlxGroup();
			density = 10;
			firstRun = true;
			
			var bmd:BitmapData = FlxG.createBitmap(Width, Height, 0x0, false, "Nebula1");
			FlxG.flashGfx.lineStyle(0, 0xFFFFFF);
			var circlePos:Point;
			var circleRad:Number;
			for (var i:int = 0; i < numCircles; i++) {
				FlxG.flashGfx.beginFill(0xFFFFFF, 1);
				circlePos = new Point(FlxG.random() * Width, FlxG.random() * Height);
				circleRad = FlxG.random() * 30;
				if (circlePos.x - circleRad < 0)
					circlePos.x += circleRad - circlePos.x +2;
				if (circlePos.x + circleRad > Width)
					circlePos.x -= circleRad + circlePos.x - Width +2;
				if (circlePos.y - circleRad < 0)
					circlePos.y += circleRad - circlePos.y +2;
				if (circlePos.y + circleRad > Height)
					circlePos.y -= circleRad + circlePos.y - Height +2;
				FlxG.flashGfx.drawCircle(circlePos.x, circlePos.y, circleRad);
				FlxG.flashGfx.endFill();
			}
			bmd.draw(FlxG.flashGfxSprite);
			//Convert the image into a tilemap
			var map:String = FlxTilemap.bitmapToCSV(bmd, true, 1);
			nebula = new FlxTilemap();
			//tile the map
			nebula.isNebula = true;
			nebula.loadMap(map, graphicAssets.NEBULA_TILES2, 40, 40, FlxTilemap.ALT);
			nebula.x = X;
			nebula.y = Y;
			
			if(Registry.nebulaLocations == null){
				Registry.nebulaLocations = new Vector.<Point>;
			}
			Registry.nebulaLocations.push(new Point(500, 500));
			
			//flashes
			var helperPoint:FlxPoint = new FlxPoint(0, 0);
			var tmp:FlxSprite;
			for (i = 0; i < nebula.nebulaSpecialCount/density; i++) {
				tmp = new FlxSprite(0, 0);
				tmp.loadGraphic(graphicAssets.NEBULA_TRINKETS, true, false, 15, 15);
				tmp.addAnimation("glow1", [0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1], FlxG.random()*40+10);
				tmp.addAnimation("glow2", [0, 1, 0, 1, 0, 1, 2, 1, 2, 1, 2, 1, 0, 1, 0, 1], FlxG.random()*40+10);
				do {
					helperPoint.x = FlxG.random() * nebula.width + nebula.x;
					helperPoint.y = FlxG.random() * nebula.height + nebula.y;
				}while (!nebula.overlapsPoint(helperPoint))
				tmp.x = helperPoint.x;
				tmp.y = helperPoint.y;
				tmp.play(FlxG.random() < .5 ? "glow2" : "glow1");
				flashes.add(tmp);
			}
		}
		override public function preUpdate():void 
		{
			super.preUpdate();
			if (nebula.onScreen()) {
				nebula.preUpdate();
				sparkles.preUpdate();
				flashes.preUpdate();
			}
		}
		override public function update():void 
		{
			super.update();
			if (nebula.onScreen()) {
				nebula.update();
				sparkles.update();
				flashes.update();
			}
		}
		override public function postUpdate():void 
		{
			super.postUpdate();
			if (nebula.onScreen()) {
				nebula.postUpdate();
				sparkles.postUpdate();
				flashes.postUpdate();
			}
		}
		override public function draw():void 
		{
			super.draw();
			if (nebula.onScreen()) {
				nebula.draw();
				sparkles.draw();
				flashes.draw();
			}
		}
	}
}