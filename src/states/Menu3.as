package states 
{
	import assets.graphicAssets;
	import org.flixel.*;
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Menu3 extends ManagedState 
	{
		public var backing:FlxSprite;
		public var selector:FlxSprite;
		public var menuIndex:int;
		public function Menu3() 
		{
			backing = new FlxSprite(245, 143, graphicAssets.MENU_THREE);
			backing.scrollFactor.make(0, 0);
			
			selector = new FlxSprite(249, 183, graphicAssets.MENU_SELECTOR);
			selector.scrollFactor.make(0, 0);
			
			menuIndex = 0;
			
			add(backing);
			add(selector);
		}
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.justPressed("DOWN")) {
				menuIndex++;
				if (menuIndex > 3)
					menuIndex = 0;
			}
			if (FlxG.keys.justPressed("UP")) {
				menuIndex--;
				if (menuIndex < 0)
					menuIndex = 3;
			}
			switch(menuIndex) {
				case 0:
					//Starmap
					selector.y = 183;
					break;
				case 1:
					//Land
					selector.y = 200;
					break;
				case 2:
					//Orbit
					selector.y = 217;
					break;
				case 3:
					//Back
					selector.y = 298;
					break;
			}
			if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("ENTER")) {
				switch(menuIndex) {
					case 0:
						//Starmap
						//FlxG.resetInput();
						StateManager.masterState.addState(new Starmap);
						break;
					case 1:
						//Land
						break;
					case 2:
						//Orbit
						break;
					case 3:
						//Back
						exitMenu();
						break;
				}
			}
			if (FlxG.keys.justPressed("ESCAPE")) {
				exitMenu();
			}
		}
		private function exitMenu():void {
			FlxG.resetInput();
			StateManager.masterState.popState();
		}
	}
}