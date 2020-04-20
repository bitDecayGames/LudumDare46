package entities.enemies;

import flixel.system.FlxAssets.FlxGraphicAsset;
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
		initAnimations(AssetPaths.Bear__png);
		name = "bear";
		personalBubble = 10;
		speed = 90;
		attackDistance = 10;
		maxWaitTime = 0.25;
		maxChaseTime = 5.0;
		hitsOtherEnemies = true;
		randomizeStats();
		toggleConfusion();
	}

	override public function initAnimations(graphic:FlxGraphicAsset):Void {
		super.initAnimations(graphic);
		animation.add("attack_0", [40, 41, 42, 43], 15, false);
		hitboxes.register(hitboxMgr.addUniversalHitbox, "attack_0", 3, [new HitboxLocation(13, 11, 13, 0)]);
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
					var enemy = cast(s, Enemy);
					if (enemy != null && (enemy.enemyState == CHASING || enemy.enemyState == HIT) && this.name != enemy.name) {
						dist = minDist;
						target = s;
					}
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
