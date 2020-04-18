package entities.enemies;

import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import actions.Actions;
import flixel.FlxSprite;
import entities.Player;
import entities.Enemy;

class ConfusedZombie extends RegularAssZombie {
	private var timer = 0.0;
	private var maxWaitTime = 2.0;
	private var maxChaseTime = 3.0;
	private var confused = false;
	private var rnd:FlxRandom;

	public function new(player:Player) {
		super(player);
		super.initAnimations(AssetPaths.Zombie__png);
		personalBubble = 50;
		speed = 50;
		rnd = new FlxRandom();
	}

	public override function update(delta:Float):Void {
		super.update(delta);
		timer -= delta;
		if (timer < 0) {
			toggleConfusion();
		}
	}

	function toggleConfusion() {
		confused = !confused;
		timer = rnd.float(0, confused ? maxWaitTime : maxChaseTime);
	}

	override function calculateVelocity() {
		if (enemyState == CHASING) {
			if (!confused) {
				super.calculateVelocity();
			} else {
				velocity.set(0, 0);
			}
		}
	}
}
