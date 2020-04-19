package entities;

import flixel.math.FlxVector;
import managers.HitboxManager;
import hitbox.HitboxSprite;
import hitbox.HitboxLocation;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import actions.Actions;
import flixel.FlxSprite;
import hitbox.AttackHitboxes;

class Player extends FlxSprite {
	public var playerGroup:PlayerGroup;
	public var hitboxMgr:HitboxManager;

	var inControl = false;
	var control = new Actions();

	var speed = 70;
	var waitForFinish = false;

	var hurtboxSize = new FlxPoint(20, 4);

	var hitboxes:AttackHitboxes;

	public function new(playerGroup:PlayerGroup, hitboxMgr:HitboxManager) {
		super();
		this.playerGroup = playerGroup;
		this.hitboxMgr = hitboxMgr;

		super.loadGraphic(AssetPaths.Player__png, true, 32, 48);

		// an extra -2 on the y to help account for empty space at the bottom of the sprites
		offset.set(width / 2 - hurtboxSize.x / 2, height - hurtboxSize.y - 2);
		setSize(hurtboxSize.x, hurtboxSize.y);

		setFacingFlip(FlxObject.UP | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		setFacingFlip(FlxObject.UP | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 5);
		animation.add("walk", [10, 11, 12, 13], 5);
		animation.add("carry_walk", [14, 15, 16, 17], 5);
		animation.add("run", [20, 21, 22, 23], 5);
		animation.add("carry_run", [24, 25, 26, 27], 5);
		animation.add("pickup", [30, 31], 10, false);
		animation.add("carry_idle", [31], 5);
		animation.add("throw", [32, 33, 34], 15, false);
		animation.add("punch", [41, 42, 43], 10, false);
		animation.add("fall_left", [35, 37], 3, false);
		animation.add("fall_right", [36,37], 3, false);

		hitboxes = new AttackHitboxes(this);
		hitboxes.register(hitboxMgr.addPlayerHitbox, "punch", 2, [new HitboxLocation(13, 15, 13, 0)]);

		animation.callback = hitboxes.animCallback;
		animation.finishCallback = tagFinish;
	}

	function tagFinish(name:String) {
		waitForFinish = false;
		hitboxes.finishAnimation();
	}

	override public function update(delta:Float):Void {
		super.update(delta);
		playerGroup.update(delta);
		hitboxes.update(delta);

		if (waitForFinish) {
			return;
		}

		// determine our velocity based on angle and speed
		velocity.set(speed, 0);

		var newFacing = 0;
		var newAngle:Float = 0;
		if (control.up.check()) {
			newFacing = newFacing | FlxObject.UP;

			newAngle = -90;
			if (control.left.check()) {
				newAngle -= 45;
				newFacing = newFacing | FlxObject.LEFT;
			} else if (control.right.check()) {
				newAngle += 45;
				newFacing = newFacing | FlxObject.RIGHT;
			}
		} else if (control.down.check()) {
			newFacing = FlxObject.DOWN;
			newAngle = 90;
			if (control.left.check()) {
				newAngle += 45;
				newFacing = newFacing | FlxObject.LEFT;
			} else if (control.right.check()) {
				newAngle -= 45;
				newFacing = newFacing | FlxObject.RIGHT;
			}
		} else if (control.left.check()) {
			newAngle = 180;
			newFacing = newFacing | FlxObject.LEFT;
		} else if (control.right.check()) {
			newAngle = 0;
			newFacing = newFacing | FlxObject.RIGHT;
		} else {
			// no keys pressed, don't move
			velocity.set(0, 0);
		}

		if (FlxG.keys.justPressed.P) {
			// Filler punch controls
			if (playerGroup.activelyCarrying) {
				velocity.set(0, 0);
				playerGroup.throwThing();
			} else {
				animation.play("punch");
				waitForFinish = true;
				velocity.set(0, 0);
			}
			return;
		}

		facing = newFacing;

		velocity.rotate(FlxPoint.weak(0, 0), newAngle);

		var carryPrefix =  playerGroup.activelyCarrying ? "carry_" : "";
		// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
			animation.play(carryPrefix + "walk");
		} else {
			animation.play(carryPrefix + "idle");
		}
	}

	public function hoist() {
		animation.play("pickup");
		waitForFinish = true;
	}

	public function chuck() {
		animation.play("throw");
		waitForFinish = true;
	}

	public function getHit(direction:FlxVector, force:Float = 1) {
		velocity.add(direction.x * force, direction.y * force);
		animation.play("fall_" + animationDirection(direction.x));
		velocity.set(0, 0);
		waitForFinish = true;
	}

	private function animationDirection(hitDirX:Float):String {
		var toTheLeft = hitDirX > 0;
		var facingLeft = flipX;
		return (toTheLeft && facingLeft) || (!toTheLeft && !facingLeft) ? "left" : "right";
	}
}
