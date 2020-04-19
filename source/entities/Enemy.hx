package entities;

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
}

class Enemy extends FlxSprite {
	var speed = 300.0; // to remind people to change this for each enemy individually
	var personalBubble = 50.0;
	var attackDistance = 20.0;
	var player:Player;
	var enemyState:EnemyState;
	var rnd:FlxRandom;
	var invulnerableWhileAttacking = true;

	var playerSafeHitboxes:AttackHitboxes;

	public var flock:EnemyFlock;

	public function new(player:Player, playerHitboxesGroup:FlxTypedGroup<HitboxSprite>) {
		super();
		rnd = new FlxRandom();
		this.player = player;
		enemyState = CHASING;

		setFacingFlip(FlxObject.UP | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		setFacingFlip(FlxObject.UP | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		playerSafeHitboxes = new AttackHitboxes(this, playerHitboxesGroup);
	}

	// MW need to call this from the new function in a subclass
	public function initAnimations(graphic:FlxGraphicAsset):Void {
		super.loadGraphic(graphic, true, 32, 48);
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

		animation.add("fall_left", [35, 37], 2, false);
		animation.add("fall_right", [36, 37], 2, false);
		animation.add("down", [37, 37, 37, 37, 37], 3, false);

		animation.add("get_up", [30, 30], 2, false);

		animation.add("carried", [37], 0);

		playerSafeHitboxes.register("fall_left", 0, [new HitboxLocation(50, 50, 0, 0), new HitboxLocation(50, 50, 0, 0)]);
		playerSafeHitboxes.register("fall_right", 0, [new HitboxLocation(50, 50, 0, 0), new HitboxLocation(50, 50, 0, 0)]);
		animation.callback = playerSafeHitboxes.animCallback;
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

		if (shouldAttack()) {
			attack();
		}

		// TODO: MW take this debug thing out
		if (FlxG.keys.justPressed.SPACE) {
			takeHit(player.getPosition(), 30);
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

	public function takeHit(hitterPosition:FlxPoint, force:Float = 1, strong:Bool = false):Void {
		if (strong) {
			switch (enemyState) {
				case HIT | GETTING_UP | CHASING | ATTACKING:
					var hitDirection = new FlxVector(x - hitterPosition.x, y - hitterPosition.y);
					hitDirection.normalize();
					beThrown(hitDirection, force);
					FlxSpriteUtil.flicker(this, 0.3);
				case KNOCKED_OUT | FALLING | CARRIED: // do nothing
			}
		} else {
			switch (enemyState) {
				case HIT | GETTING_UP:
					var hitDirection = new FlxVector(x - hitterPosition.x, y - hitterPosition.y);
					hitDirection.normalize();
					beThrown(hitDirection, force);
					FlxSpriteUtil.flicker(this, 0.3);
				case CHASING:
					animation.play("hit_" + animationDirection(x - hitterPosition.x));
					enemyState = HIT;
					velocity.set(0, 0);
					FlxSpriteUtil.flicker(this, 0.3);
				case ATTACKING:
					if (!invulnerableWhileAttacking) {
						animation.play("hit_" + animationDirection(x - hitterPosition.x));
						enemyState = HIT;
						velocity.set(0, 0);
						FlxSpriteUtil.flicker(this, 0.3);
					}
				case KNOCKED_OUT | FALLING | CARRIED: // do nothing
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
		enemyState = GETTING_UP;
		animation.play("get_up");
	}

	public function getKnockedOut():Void {
		enemyState = KNOCKED_OUT;
		velocity.set(0, 0);
		animation.play("down");
	}

	private function finishAnimation(animationName:String):Void {
		if (animationName != null) {
			if (animationName.indexOf("attack") >= 0) {
				enemyState = CHASING;
			} else if (animationName.indexOf("fall") >= 0) {
				getKnockedOut();
				playerSafeHitboxes.finishAnimation();
			} else if (animationName.indexOf("hit") >= 0) {
				enemyState = CHASING;
			} else if (animationName.indexOf("get_up") >= 0) {
				enemyState = CHASING;
			} else if (animationName.indexOf("down") >= 0) {
				getUpOffTheGround();
			}
		}
	}

	private function animationDirection(hitDirX:Float):String {
		var toTheLeft = hitDirX > 0;
		var facingLeft = (facing & FlxObject.LEFT) != 0;
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
