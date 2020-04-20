package entities.enemies;

import flixel.math.FlxVector;
import hitbox.HitboxLocation;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import managers.HitboxManager;
import entities.Player;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class SmokeyTheBear extends ConfusedZombie {
	var curTarget:FlxSprite;

	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		super.initAnimations(AssetPaths.Bear__png);
		name = "bear";
		personalBubble = 100;
		speed = 70;
		maxWaitTime = 0.5;
		maxChaseTime = 5.0;
		hitsOtherEnemies = true;
		randomizeStats();
	}

	override function shouldAttack():Bool {
		return curTarget != null && FlxMath.distanceBetween(this, curTarget) <= attackDistance;
	}

	override function toggleConfusion() {
		super.toggleConfusion();
		if (!confused) {
			curTarget = findNearestOther();
		}
	}

	function findNearestOther():FlxSprite {
		var target:FlxSprite = hitboxMgr.getPlayer();
		var minDist = FlxMath.distanceBetween(this, target);
		if (flock != null) {
			flock.forEachAlive((s) -> {
				var dist = FlxMath.distanceBetween(this, s);
				if (dist < minDist) {
					target = s;
				}
			});
		}
		return target;
	}

	override function moveTowardsPlayer():FlxVector {
		var v = new FlxVector(0, 0);
		if (curTarget != null) {
			var target = curTarget.getPosition();
			var direction = target.subtract(x, y);
			v.set(direction.x, direction.y);
			v.normalize();
			v.scale(speed);
		}
		return v;
	}
}
