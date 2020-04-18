package entities;

import flixel.FlxG;
import flixel.input.keyboard.FlxKeyboard.FlxKeyInput;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import actions.Actions;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

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
	var speed = 120.0;
	var personalBubble = 50.0;
	var player:Player;
	var enemyState:EnemyState;
	var attackDistance = 20.0;

	public var flock:EnemyFlock;

	public function new(player:Player) {
		super();
		this.player = player;
		enemyState = CHASING;

		setFacingFlip(FlxObject.UP | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		setFacingFlip(FlxObject.UP | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.LEFT, true, false);
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
		animation.add("down", [37, 37, 37, 37, 37], 2, false);

		animation.add("get_up", [30, 30], 2, false);

		animation.add("carried", [37], 0);

		animation.finishCallback = finishAnimation;
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		if (player != null && FlxMath.distanceBetween(this, player) <= attackDistance) {
			attack();
		}

		if (FlxG.keys.justPressed.SPACE) {
			takeHit(player.getPosition(), 10);
		}
		var lastFacing = facing;

		calculateVelocity();

		if (enemyState == CHASING) {
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

	function keepDistanceFromOtherZombies():FlxVector {
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
		}
	}

	public function takeHit(hitterPosition:FlxPoint, force:Float = 1, strong:Bool = false):Void {
		if (strong) {
			switch (enemyState) {
				case HIT | GETTING_UP | CHASING | ATTACKING:
					var hitDirection = new FlxVector(x - hitterPosition.x, y - hitterPosition.y);
					hitDirection.normalize();
					beThrown(hitDirection, force);
				case KNOCKED_OUT | FALLING | CARRIED: // do nothing
			}
		} else {
			switch (enemyState) {
				case HIT | GETTING_UP:
					var hitDirection = new FlxVector(x - hitterPosition.x, y - hitterPosition.y);
					hitDirection.normalize();
					beThrown(hitDirection, force);
				case CHASING:
					animation.play("hit_" + (hitterPosition.x > x ? "left" : "right"));
					enemyState = HIT;
					velocity.set(0, 0);
				case KNOCKED_OUT | FALLING | ATTACKING | CARRIED: // do nothing
			}
		}
	}

	public function pickUp():Void {
		enemyState = CARRIED;
		animation.play("carried");
	}

	public function beThrown(direction:FlxVector, force:Float = 1):Void {
		velocity.add(direction.x * force, direction.y * force);
		animation.play("fall_" + (direction.x < 0 ? "left" : "right"));
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
			} else if (animationName.indexOf("hit") >= 0) {
				enemyState = CHASING;
			} else if (animationName.indexOf("get_up") >= 0) {
				enemyState = CHASING;
			} else if (animationName.indexOf("down") >= 0) {
				getUpOffTheGround();
			}
		}
	}

	// override this for the different enemy behaviours
	function calculateVelocity() {
		if (enemyState == CHASING) {
			var move = moveTowardsPlayer();
			var keepDistance = keepDistanceFromOtherZombies();
			velocity.set(move.x + keepDistance.x, move.y + keepDistance.y);
		}
	}
}
