package entities;

import flixel.math.FlxVector;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class TreeTrunk extends FlxSprite {
	public var parentTree:Tree;

	public var hasLog:Bool = true;

	var logGenerateTime:Float = 3;
	var logTimer:Float = 0;

	public function new(parent:Tree) {
		super();
		super.loadGraphic(AssetPaths.Trunk__png);

		parentTree = parent;

		var hurtboxWidth = 42;
		var hurtboxHeight = 22;

		offset.set((width / 2) - (hurtboxWidth / 2), height - hurtboxHeight);
		setSize(hurtboxWidth, hurtboxHeight);

		immovable = true;
	}

	public function spawnLog(interact:FlxVector):TreeLog {
		if (interact.x < 0) {
			parentTree.top.animation.play("hitFromLeft");
		} else {
			parentTree.top.animation.play("hitFromRight");
		}
		
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