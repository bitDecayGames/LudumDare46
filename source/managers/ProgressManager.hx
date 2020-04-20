package managers;

import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxG;
import screens.GameScreen;
import flixel.FlxBasic;
import entities.ProgressMeter;
import entities.ProgressCover;

class ProgressManager extends FlxGroup {
	var game:GameScreen;

	var progressOmeter:ProgressMeter;
	var progCover:ProgressCover;

	static inline var MINUTE_TO_WINUTES = 1;

	var winTime:Float = MINUTE_TO_WINUTES * 60;
	var elapsedTime:Float = 0.0;
	var isTimerGoing:Bool = false;

	public function new(game:GameScreen) {
		super();
		this.game = game;
		progCover = new ProgressCover();
		progressOmeter = new ProgressMeter(progCover.getMidpoint());
		add(progressOmeter);
		add(progCover);
		
	}

	public function startProgressTimer() {
        isTimerGoing = true;
	}

	override public function update(delta:Float) {
		super.update(delta);
		if(isTimerGoing){
			elapsedTime += delta;
		}
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