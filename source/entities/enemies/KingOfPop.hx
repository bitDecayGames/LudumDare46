package entities.enemies;

import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import managers.HitboxManager;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class KingOfPop extends Enemy {
	private var timer = 0.0;
	private var danceFrameIndex = 0;
	private var danceInfluenceRadius = 0.0;
	private var influencePerSecond = 5.0;

	private var startedDancing = false;

	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		super.initAnimations(AssetPaths.Jackson__png);
		animation.add("spin", [40, 41, 42, 43, 44, 43, 44, 40, 40, 40], 3, false);
		personalBubble = 50;
		speed = 40;
		attackDistance = 100;
		danceInfluenceRadius = 80.0;
		randomizeStats();
		startChasing();
	}

	public override function update(delta:Float):Void {
		super.update(delta);
		timer -= delta;
		if (timer < 0) {}
		if (startedDancing) {
			danceInfluenceRadius += influencePerSecond * delta;
		}
	}

	// no mere mortal can resist...
	private function sendOutTheEvilOfTheThriller() {
		if (flock != null) {
			for (enemy in flock.enemies) {
				if (enemy != null
					&& enemy != this
					&& enemy.enemyState != DANCING
					&& FlxMath.distanceBetween(this, enemy) < danceInfluenceRadius) {
					enemy.startDancing(danceFrameIndex);
				}
			}
		}
	}

	override public function takeHit(hitterPosition:FlxPoint, force:Float = 1, strong:Bool = false):Void {
		if (enemyState == DANCING) {
			breakTheSpell();
		}
		super.takeHit(hitterPosition, force, strong);
	}

	private function breakTheSpell() {
		danceInfluenceRadius *= 0.4;

		if (flock != null) {
			for (enemy in flock.enemies) {
				if (enemy != null && enemy != this && enemy.enemyState == DANCING) {
					enemy.startChasing();
				}
			}
		}
	}

	override public function startChasing():Void {
		if (startedDancing) {
			enemyState = OTHER;
			animation.play("spin", true, false, 0);
			velocity.set(0, 0);
		} else {
			super.startChasing();
		}
	}

	override public function attack():Void {
		if (!startedDancing) {
			startedDancing = true;
			startChasing();
		}
	}

	override private function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
		super.animCallback(name, frameNumber, frameIndex);
		if (name == "dance" && frameNumber == 0) {
			sendOutTheEvilOfTheThriller();
		}
	}

	override private function finishAnimation(animationName:String):Void {
		super.finishAnimation(animationName);
		if (animationName == "spin") {
			startDancing(0, true);
		}
	}

	override function calculateVelocity() {
		if (!startedDancing) {
			super.calculateVelocity();
		}
	}
}
