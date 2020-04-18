package entities;

import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import actions.Actions;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Enemy extends FlxSprite {
	var speed = 120.0;
	var personalBubble = 50.0;
	var player:Player;

	public var flock:EnemyFlock;

	public function new(player:Player) {
		super();
		this.player = player;

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
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		var lastFacing = facing;

		calculateVelocity();

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

	// override this for the different enemy behaviours
	function calculateVelocity() {
		var move = moveTowardsPlayer();
		var keepDistance = keepDistanceFromOtherZombies();
		velocity.set(move.x + keepDistance.x, move.y + keepDistance.y);
	}
}
