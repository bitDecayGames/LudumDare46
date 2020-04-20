package entities;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class ProgressMeter extends FlxSprite {
	var progress:Float = -1.0;

	public function new(center:FlxPoint) {
		super();
		loadGraphic(AssetPaths.dial__png);
		updateHitbox();

		this.setMidpoint(center.x, center.y);
		scrollFactor.set(0, 0);
	}

	public function setProgress(p:Float) {
		progress = Math.min(1, p);
	}

	override public function update(delta:Float) {
		super.update(delta);
		angle = 180 * progress;
		FlxG.watch.addQuick("prog: ", progress);
	}
}