package managers;

import flixel.group.FlxGroup;
import flixel.FlxG;
import screens.GameScreen;
import flixel.FlxBasic;
import entities.ProgressMeter;

class ProgressManager extends FlxGroup {
	var game:GameScreen;

	var progressOmeter:ProgressMeter;

	static inline var MINUTE_TO_WINUTES = 1;

	var winTime:Float = MINUTE_TO_WINUTES * 60;
	var elapsedTime:Float = 0.0;

	public function new(game:GameScreen) {
		super();
		this.game = game;
		progressOmeter = new ProgressMeter();
		add(progressOmeter);
	}

	override public function update(delta:Float) {
		super.update(delta);
		
		elapsedTime += delta;
		var normalized = (elapsedTime / winTime);
		var shaderTime = Math.pow(normalized, 5);
		game.shader.time.value = [shaderTime];

		progressOmeter.setProgress(normalized);
		FlxG.watch.addQuick("progManProg: ", normalized);
	}

	public function hasWon():Bool {
		return elapsedTime >= winTime;
	}
}