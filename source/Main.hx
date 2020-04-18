package;

import screens.MainMenuScreen;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, MainMenuScreen, 1, 60, 60, true, false));
	}
}
