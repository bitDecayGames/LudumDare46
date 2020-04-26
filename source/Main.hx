package;

import faxe.Faxe;
import screens.WinScreen;
import flixel.FlxG;
import screens.MainMenuScreen;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import screens.SplashScreen;
import screens.GameScreen;
import flixel.FlxGame;
import openfl.display.Sprite;
import analytics.Analytics;

class Main extends Sprite {
	public function new() {
		super();
		FlxG.fixedTimestep = false;
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		addChild(new FlxGame(0, 0, SplashScreen, 1, 60, 60, true, false));

		//Analytics.createGameGUID();
		//Analytics.send(Analytics.GAME_LOADED);
	}
}
