package states 
{
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Zachary Tarvit
	 */
	public class StateManager extends FlxState 
	{
		public static var masterState:StateManager;
		private var stateStack:Vector.<ManagedState>;
		private var drawIndex:int = 0;
		
		public function StateManager() 
		{
			stateStack = new Vector.<ManagedState>();
		}
		
		override public function create():void 
		{
			super.create();
			newStack(new MainMenu());
			masterState = this;
		}
		
		override public function preUpdate():void 
		{
			super.preUpdate();
			for (var i:int = stateStack.length-1; i >= 0; i--) {
				stateStack[i].preUpdate();
				if (!stateStack[i].passUpdate)
					break;
			}
		}
		
		override public function update():void 
		{
			super.update();
			for (var i:int = stateStack.length-1; i >= 0; i--) {
				stateStack[i].update();
				if(i < stateStack.length)
					if (!stateStack[i].passUpdate)
						break;
			}
		}
		
		override public function postUpdate():void 
		{
			super.postUpdate();
			for (var i:int = stateStack.length-1; i >= 0; i--) {
				stateStack[i].postUpdate();
				if (!stateStack[i].passUpdate)
					break;
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			//We need to draw from the bottom up, but the top-most states could refuse to allow drawing under them.
			//We need to start from the top, and work our way down to find the first that doesn't allow render to pass through.
			//Then draw backwards from there.
			for (var i:int = stateStack.length-1; i >= 0; i--) {
				if (!stateStack[i].passDraw || i == 0){
					drawIndex = i;
					break;
				}
			}
			for (i = drawIndex; i < stateStack.length; i++) {
				stateStack[i].draw();
			}
		}
		
		//Pushes a new state onto the stack. Consumes the update and draw calls.
		public function addState(newState:ManagedState):void {
			stateStack.push(newState);
			newState.create();
		}
		
		//Knocks off the most recent state, useful for closing options menus
		public function popState():void {
			stateStack[stateStack.length - 1].destroy();
			stateStack.pop();
			stateStack[stateStack.length - 1].recoverControl();
		}
		
		//Useful for going from like, main menu to an in-game state.
		public function newStack(startState:ManagedState):void {
			stateStack = new Vector.<ManagedState>();
			stateStack.push(startState);
			startState.create();
		}
	}
}