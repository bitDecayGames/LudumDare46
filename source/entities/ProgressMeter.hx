package entities;

import flixel.FlxG;
import flixel.FlxSprite;

class ProgressMeter extends FlxSprite {
	var progress:Float;

	public function new() {
		super();
		loadGraphic(AssetPaths.dial__png);
		updateHitbox();

		x = FlxG.camera.width / 2 - width + (FlxG.camera.width / 2) / FlxG.camera.zoom;
		y = FlxG.camera.height / 2 - (FlxG.camera.height / 2)  / FlxG.camera.zoom;

		scrollFactor.set(0, 0);
	}

	public function setProgress(p:Float) {
		progress = Math.max(0, Math.min(1, p));
	}

	override public function update(delta:Float) {
		super.update(delta);
		angle = 180 * progress;
		FlxG.watch.addQuick("prog: ", progress);
	}
}