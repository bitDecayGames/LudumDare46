package managers;

import flixel.FlxG;
import screens.GameScreen;
import flixel.FlxBasic;

class ProgressManager extends FlxBasic {
	var game:GameScreen;

	static inline var MINUTE_TO_WINUTES = 1;

	var winTime:Float = MINUTE_TO_WINUTES * 60;
	var elapsedTime:Float = 0.0;

	public function new(game:GameScreen) {
		super();
		this.game = game;
	}

	override public function update(delta:Float) {
		elapsedTime += delta;
		var normalized = (elapsedTime / winTime);
		var shaderTime = Math.pow(normalized, 5);
		game.shader.time.value = [shaderTime];
		FlxG.watch.addQuick("norm time: ", normalized);
		FlxG.watch.addQuick("shad time: ", shaderTime);
	}

	public function hasWon():Bool {
		return elapsedTime >= winTime;
	}
}