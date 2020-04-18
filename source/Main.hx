package;

import states.MovementState;
import screens.GameScreen;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, GameScreen, 1, 60, 60, true, false));
	}
}
