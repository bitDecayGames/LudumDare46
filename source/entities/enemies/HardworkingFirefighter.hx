package entities.enemies;

import flixel.addons.display.FlxNestedSprite;
import managers.HitboxManager;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.FlxSprite;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class HardworkingFirefighter extends Enemy {
	var firepit:FlxSprite;

	public function new(hitboxMgr:HitboxManager, firepit:FlxSprite) {
		super(hitboxMgr);
		this.firepit = firepit;
		super.initAnimations(AssetPaths.Firefighter__png);
		personalBubble = 50;
		speed = 30;
		attackDistance = 100;
		randomizeStats();
		invulnerableWhileAttacking = false;
	}

	function moveTowardsFirepit():FlxVector {
		var v = new FlxVector(0, 0);
		if (firepit != null) {
			var target = firepit.getPosition();
			var direction = target.subtract(x, y);
			v.set(direction.x, direction.y);
			v.normalize();
			v.scale(speed);
		}
		return v;
	}

	override function shouldAttack():Bool {
		return firepit != null && FlxMath.distanceBetween(this, firepit) <= attackDistance;
	}

	override function attack():Void {
		super.attack();
		// TODO: put the hose spray logic here
	}

	override function calculateVelocity() {
		if (enemyState == CHASING) {
			var move = moveTowardsFirepit();
			var keepDistance = keepDistanceFromOtherEnemies();
			velocity.set(move.x + keepDistance.x, move.y + keepDistance.y);
		}
	}
}
