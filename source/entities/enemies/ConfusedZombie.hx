package entities.enemies;

import managers.HitboxManager;
import entities.Player;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class ConfusedZombie extends RegularAssZombie {
	private var timer = 0.0;
	private var maxWaitTime = 2.0;
	private var maxChaseTime = 3.0;
	private var confused = false;

	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		super.initAnimations(AssetPaths.Zombie__png);
		personalBubble = 50;
		speed = 40;
		randomizeStats();
	}

	public override function randomizeStats() {
		super.randomizeStats();
		maxWaitTime = randomizeStat(maxWaitTime);
		maxChaseTime = randomizeStat(maxChaseTime);
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
