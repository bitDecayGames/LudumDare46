package entities;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class Tree extends FlxSprite {

	public var hasLog:Bool = true;

	var logGenerateTime:Float = 3;
	var logTimer:Float = 0;

	public function new() {
		super();
		super.loadGraphic(AssetPaths.testTree__png);

		var hurtboxWidth = 42;
		var hurtboxHeight = 22;

		offset.set((width / 2) - (hurtboxWidth / 2), height - hurtboxHeight);
		setSize(hurtboxWidth, hurtboxHeight);

		immovable = true;
	}

	public function spawnLog():TreeLog {
		hasLog = false;
		var log = new TreeLog();
		log.setMidpoint(getMidpoint().x, getMidpoint().y + 30);
		return log;
	}

	override public function update(delta:Float) {
		super.update(delta);
		if (!hasLog) {
			if (logTimer <= 0) {
				// start our timer
				logTimer = logGenerateTime;
			}

			logTimer -= delta;

			if (logTimer <= 0) {
				hasLog = true;
			}
		}
	}
}