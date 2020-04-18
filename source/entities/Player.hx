package entities;

import flixel.math.FlxPoint;
import flixel.FlxObject;
import actions.Actions;
import flixel.FlxSprite;

class Player extends FlxSprite {
	var inControl = false;
	var control = new Actions();

	var speed = 200;

	public function new() {
		super();
		super.loadGraphic(AssetPaths.sailor_all__png, true, 16, 32);

		setFacingFlip(FlxObject.UP | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		setFacingFlip(FlxObject.UP | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		animation.add("walk", [4, 5, 6, 7], 5);

		animation.add("u", [2], 0);
		animation.add("d", [0], 0);
		animation.add("l", [1], 0);
		animation.add("r", [1], 0);
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		var lastFacing = facing;

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

		facing = newFacing;

		velocity.rotate(FlxPoint.weak(0, 0), newAngle);

		// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
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
