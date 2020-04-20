package entities;

import audio.SoundBankAccessor;
import audio.BitdecaySoundBank;
import managers.HitboxManager;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import hitbox.AttackHitboxes;
import hitbox.HitboxLocation;
import hitbox.HitboxSprite;
import flixel.group.FlxGroup;

enum EnemyState {
	CHASING;
	ATTACKING;
	HIT;
	KNOCKED_OUT;
	FALLING;
	GETTING_UP;
	CARRIED;
	DANCING;
	OTHER;
}

class Enemy extends Throwable {
	var speed = 300.0; // to remind people to change this for each enemy individually
	var personalBubble = 50.0;
	var attackDistance = 20.0;
	var player:Player;
	var enemyState:EnemyState;
	var rnd:FlxRandom;
	var invulnerableWhileAttacking = false;

	public var hitsOtherEnemies = false;

	var playerSafeHitboxes:AttackHitboxes;

	public var flock:EnemyFlock;

	var hurtboxSize = new FlxPoint(20, 4);

	public var hitboxMgr:HitboxManager;

	var stunTime:Float = 0;
	private var danceTurnFrames:Array<Int>;

	public function new(hitboxMgr:HitboxManager) {
		super();
		inFlightHitboxScale = 3;
		rnd = new FlxRandom();
		this.hitboxMgr = hitboxMgr;
		this.player = hitboxMgr.getPlayer();
		enemyState = CHASING;

		setFacingFlip(FlxObject.UP | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		setFacingFlip(FlxObject.UP | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		playerSafeHitboxes = new AttackHitboxes(this);
	}

	// MW need to call this from the new function in a subclass
	public function initAnimations(graphic:FlxGraphicAsset):Void {
		super.loadGraphic(graphic, true, 32, 48);

		// an extra -2 on the y to help account for empty space at the bottom of the sprites
		offset.set(width / 2 - hurtboxSize.x / 2, height - hurtboxSize.y - 2);
		setSize(hurtboxSize.x, hurtboxSize.y);

		// MW this stuff might need to go into the actual enemy implementations
		animation.add("stand", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		animation.add("walk", [10, 11, 12, 13], 5);

		animation.add("u", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		animation.add("d", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		animation.add("l", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		animation.add("r", [0, 1, 2, 3, 4, 5, 6, 7], 5);

		animation.add("attack_0", [40, 41, 42, 43], 5, false);

		animation.add("hit_left", [45], 2, false);
		animation.add("hit_right", [46], 2, false);

		animation.add("fall_left", [35], 2, false);
		animation.add("fall_right", [36], 2, false);
		animation.add("down", [37], 1);

		animation.add("get_up", [30, 30], 2, false);

		animation.add("carried", [37], 0);

		animation.add("dance", [
			0, 1, 2, 3, 4, 5, 11, 11, 0, 11, 11, 11, 0, 1, 2, 3, 45, 35, 30, 46, 46, 36, 0, 1, 30, 30, 30, 30, 11, 11, 30, 11, 11, 11, 30, 30
		], 5);
		danceTurnFrames = [5, 8, 16, 28, 31];

		playerSafeHitboxes.register(hitboxMgr.addIntraEnemyHitbox, "fall_left", 0, [
			new HitboxLocation(hurtboxSize.x * 1.5, hurtboxSize.y * 2, 0, 0),
			new HitboxLocation(hurtboxSize.x * 1.5, hurtboxSize.y * 2, 0, 0)
		]);
		playerSafeHitboxes.register(hitboxMgr.addIntraEnemyHitbox, "fall_right", 0, [
			new HitboxLocation(hurtboxSize.x * 1.5, hurtboxSize.y * 2, 0, 0),
			new HitboxLocation(hurtboxSize.x * 1.5, hurtboxSize.y * 2, 0, 0)
		]);

		playerSafeHitboxes.register(hitboxMgr.addEnemyHitbox, "attack_0", 3, [new HitboxLocation(13, 11, 13, 0)]);
		animation.callback = animCallback;
		animation.finishCallback = finishAnimation;
	}

	public function randomizeStats() {
		speed = randomizeStat(speed);
		personalBubble = randomizeStat(personalBubble);
		attackDistance = randomizeStat(attackDistance);
	}

	private function randomizeStat(value:Float, deviationPercentage:Float = 0.1):Float {
		return rnd.float(value - (value * deviationPercentage), value + (value * deviationPercentage));
	}

	override public function update(delta:Float):Void {
		super.update(delta);
		playerSafeHitboxes.update(delta);

		if (!shouldUpdate) {
			return;
		}

		if (enemyState == KNOCKED_OUT) {
			stunTime -= delta;
			if (stunTime <= 0) {
				finishAnimation("down");
			}
		}

		if (shouldAttack()) {
			attack();
		}

		var lastFacing = facing;

		calculateVelocity();

		if (enemyState == CHASING) {
			calculateFacing();

			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
				animation.play("walk");
			} else {
				facing = lastFacing;
				if (lastFacing & FlxObject.LEFT != 0) {
					animation.play("l");
				} else if (lastFacing & FlxObject.RIGHT != 0) {
					animation.play("r");
				} else if (lastFacing & FlxObject.UP != 0) {
					animation.play("u");
				} else if (lastFacing & FlxObject.DOWN != 0) {
					animation.play("d");
				}
			}
		}
	}

	function shouldAttack():Bool {
		return player != null && FlxMath.distanceBetween(this, player) <= attackDistance;
	}

	public function startDancing(frame:Int, force:Bool = false):Bool {
		if (enemyState == CHASING || force) {
			enemyState = DANCING;
			animation.play("dance", true, false, frame);
			velocity.set(0, 0);
			return true;
		}
		return false;
	}

	function moveTowardsPlayer():FlxVector {
		var v = new FlxVector(0, 0);
		if (player != null) {
			var target = player.getPosition();
			var direction = target.subtract(x, y);
			v.set(direction.x, direction.y);
			v.normalize();
			v.scale(speed);
		}
		return v;
	}

	function keepDistanceFromOtherEnemies():FlxVector {
		var v = new FlxVector();
		var temp = new FlxVector();
		var enemiesInPersonalBubble = 0.0;
		var distance = 0;
		if (flock != null) {
			for (enemy in flock.enemies) {
				if (enemy != this) {
					distance = FlxMath.distanceBetween(this, enemy);
					if (distance < personalBubble) {
						// for each other enemy in your personal bubble, move away from them
						enemiesInPersonalBubble += 1.0;
						temp.set(x - enemy.x, y - enemy.y);
						temp.normalize();
						temp.scale(personalBubble - distance);
						v.add(temp.x, temp.y);
					}
				}
			}
			if (enemiesInPersonalBubble > 0) {
				// get the average of the values
				v.scale(1.0 / enemiesInPersonalBubble);
			}
		}
		return v;
	}

	function attack() {
		if (enemyState == CHASING) {
			enemyState = ATTACKING;
			animation.play("attack_0");
			velocity.set(0, 0);
		}
	}

	public function checkThrowableHit(throwable:Throwable) {
		if (throwable.state != BEING_THROWN) {
			// enemies only react to thrown things
			return;
		}

		switch (enemyState) {
			case FALLING | KNOCKED_OUT | CARRIED:
			// ignore this collision
			default:
				takeHit(throwable.getMidpoint(), 3, true);
				throwable.velocity.set(0, 0);
		}
	}

	public function takeHit(hitterPosition:FlxPoint, force:Float = 1, strong:Bool = false):Void {
		if (strong) {
			switch (enemyState) {
				case HIT | GETTING_UP | CHASING | ATTACKING | DANCING:
					var hitDirection = new FlxVector(x - hitterPosition.x, y - hitterPosition.y);
					hitDirection.normalize();
					beThrown(hitDirection, force);
					FlxSpriteUtil.flicker(this, 0.3);
					SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieHit);
					FlxG.camera.shake(0.001, .1);
				case KNOCKED_OUT | FALLING | CARRIED | OTHER: // do nothing
			}
		} else {
			switch (enemyState) {
				case HIT | GETTING_UP:
					var hitDirection = new FlxVector(x - hitterPosition.x, y - hitterPosition.y);
					hitDirection.normalize();
					beThrown(hitDirection, force);
					FlxSpriteUtil.flicker(this, 0.3);
					SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieHit);
					if (this.name == "zombie") {
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieAttack);
						FlxG.camera.shake(0.002, .1);
					} else {
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.HumanKnockout);
						FlxG.camera.shake(0.002, .1);
					}
				case CHASING | DANCING:
					animation.play("hit_" + animationDirection(x - hitterPosition.x));
					enemyState = HIT;
					velocity.set(0, 0);
					FlxSpriteUtil.flicker(this, 0.3);
					SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieHit);
					FlxG.camera.shake(0.001, .1);
				case ATTACKING:
					if (!invulnerableWhileAttacking) {
						animation.play("hit_" + animationDirection(x - hitterPosition.x));
						enemyState = HIT;
						velocity.set(0, 0);
						FlxSpriteUtil.flicker(this, 0.3);
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieHit);
						FlxG.camera.shake(0.001, .1);
					}
				case KNOCKED_OUT | FALLING | CARRIED | OTHER: // do nothing
			}
		}
	}

	public function bePickedUp():Void {
		enemyState = CARRIED;
		animation.play("carried");
	}

	public function beThrown(direction:FlxVector, force:Float = 1):Void {
		velocity.add(direction.x * force, direction.y * force);
		animation.play("fall_" + animationDirection(direction.x));
		enemyState = FALLING;
	}

	public function getUpOffTheGround():Void {
		state = DEFAULT;
		enemyState = GETTING_UP;
		animation.play("get_up");
	}

	public function getKnockedOut():Void {
		state = PICKUPABLE;
		enemyState = KNOCKED_OUT;
		stunTime = 1.67; // this was chosen based on originally playing 5 frames at 3/sec
		velocity.set(0, 0);
		animation.play("down");
	}

	public function startChasing():Void {
		enemyState = CHASING;
	}

	private function finishAnimation(animationName:String):Void {
		if (animationName != null) {
			if (animationName.indexOf("attack") >= 0) {
				startChasing();
			} else if (animationName.indexOf("fall") >= 0) {
				getKnockedOut();
				playerSafeHitboxes.finishAnimation();
			} else if (animationName.indexOf("hit") >= 0) {
				startChasing();
			} else if (animationName.indexOf("get_up") >= 0) {
				startChasing();
			} else if (animationName.indexOf("down") >= 0) {
				getUpOffTheGround();
			}
		}
	}

	private function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
		playerSafeHitboxes.animCallback(name, frameNumber, frameIndex);
		if (name == "dance") {
			var indexOfFrame = danceTurnFrames.indexOf(frameNumber);
			if (indexOfFrame >= 0) {
				if (indexOfFrame % 2 == 0) {
					facing = FlxObject.RIGHT;
				} else {
					facing = FlxObject.LEFT;
				}
			}
		}

		if (name == "attack_0" && frameNumber == 2) {
			if (this.name == "zombie") {
				SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieAttack);
			}
		}
	}

	private function animationDirection(hitDirX:Float):String {
		var toTheLeft = hitDirX > 0;
		var facingLeft = flipX;
		return (toTheLeft && facingLeft) || (!toTheLeft && !facingLeft) ? "left" : "right";
	}

	private function calculateFacing():Void {
		var newFacing = 0;
		if (velocity.x > 0) {
			newFacing = newFacing | FlxObject.RIGHT;
		} else if (velocity.x < 0) {
			newFacing = newFacing | FlxObject.LEFT;
		}
		if (velocity.y > 0) {
			newFacing = newFacing | FlxObject.DOWN;
		} else if (velocity.y < 0) {
			newFacing = newFacing | FlxObject.UP;
		}
		facing = newFacing;
	}

	// override this for the different enemy behaviours
	function calculateVelocity() {
		if (enemyState == CHASING) {
			var move = moveTowardsPlayer();
			var keepDistance = keepDistanceFromOtherEnemies();
			velocity.set(move.x + keepDistance.x, move.y + keepDistance.y);
		}
	}
}
