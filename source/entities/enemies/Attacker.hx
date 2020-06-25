package entities.enemies;

import flixel.system.FlxAssets.FlxGraphicAsset;
import managers.HitboxManager;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class Attacker extends Enemy {
	public function new(hitboxMgr:HitboxManager, graphic:FlxGraphicAsset) {
		super(hitboxMgr);
		danceSpeed = 7;
		initAnimations(graphic);
		name = "attacker";
		personalBubble = 15;
		attack();
	}

	override function shouldAttack():Bool {
		return false;
	}

	override function calculateVelocity() {
		// do nothing so that this guy just stands there and dances
	}

	override private function finishAnimation(animationName:String):Void {
		if (animationName != null) {
			if (animationName.indexOf("attack") >= 0) {
				attack();
			}
		}
	}

	override function attack() {
		enemyState = ATTACKING;
		animation.play("attack_0", true, false, 0);
		velocity.set(0, 0);
	}
}
