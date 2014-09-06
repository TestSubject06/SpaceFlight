package states 
{
	import assets.graphicAssets;
	import org.flixel.*;
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class Menu1 extends ManagedState 
	{
		public var backing:FlxSprite;
		public var selector:FlxSprite;
		public var menuIndex:int;
		public function Menu1() 
		{
			backing = new FlxSprite(245, 143, graphicAssets.MENU_ONE);
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
				if (menuIndex > 5)
					menuIndex = 0;
			}
			if (FlxG.keys.justPressed("UP")) {
				menuIndex--;
				if (menuIndex < 0)
					menuIndex = 5;
			}
			switch(menuIndex) {
				case 0:
					//Science
					selector.y = 183;
					break;
				case 1:
					//Navigation
					selector.y = 199;
					break;
				case 2:
					//Medical
					selector.y = 216;
					break;
				case 3:
					//Comms
					selector.y = 233;
					break;
				case 4:
					//Cargo
					selector.y = 250;
					break;
				case 5:
					//Resume
					selector.y = 298;
					break;
			}
			if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("ENTER")) {
				switch(menuIndex) {
					case 0:
						//Science
						break;
					case 1:
						//Navigation
						StateManager.masterState.addState(new Menu3());
						break;
					case 2:
						//Medical
						break;
					case 3:
						//Comms
						break;
					case 4:
						//Cargo
						break;
					case 5:
						//Resume
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
			Registry.starfieldsReady = true;
			StateManager.masterState.popState();
		}
	}
}