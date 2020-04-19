package entities;

import flixel.FlxG;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class Throwable extends FlxSprite {
	public var state:ThrowableState = DEFAULT;

	var defaultOffset:FlxPoint = new FlxPoint();
	var carrierOffset:FlxPoint = new FlxPoint();

	var defaultSize:FlxPoint = new FlxPoint();

	// whether child classes should do their own updates or just wait
	var shouldUpdate:Bool = true;

	var direction:FlxVector;
	var distance:Float;
	var start:FlxPoint = new FlxPoint();

	override public function update(delta:Float) {
		FlxG.watch.addQuick("Throwable's Y: ", y);
		super.update(delta);

		if (state == BEING_THROWN) {
			var lastDistance = last.distanceTo(getPosition());
			distance -= lastDistance;

			// XXX: This is to avoid collision bugs. Probably makes more sense to
			// move what group this collision object is in
			if (start.distanceTo(getPosition()) > 20) {
				// wait a bit to restore collisions so we don't have weird
				// interaction with the thrower
				solid = true;
			}

			if (distance <= 0 || cast(velocity, FlxVector).length == 0) {
				// TODO: what here? falling? 
				state = PICKUPABLE;
				shouldUpdate = true;

				// This is what's making it hit the ground
				// if we want something more complicated, it'll be done here
				resetThings();
			}
		}
	}

	public function resetThings() {
		offset.set(defaultOffset.x, defaultOffset.y);
		setSize(defaultSize.x, defaultSize.y);
	}

	public function pickUp(carrierOffset:FlxPoint) {
		this.carrierOffset = carrierOffset;
		defaultOffset.set(offset.x, offset.y);
		defaultSize.set(width, height);

		state = BEING_CARRIED;

		// no collisions
		solid = false;
		offset.set(carrierOffset.x, carrierOffset.y);
		// don't need a hitbox for anything other than proper positioning
		setSize(1, 1);
		shouldUpdate = false;
	}

	public function getThrown(direction:FlxVector, distance:Float) {
		start.set(x, y);
		state = BEING_THROWN;
		this.direction = direction;
		this.distance = distance;
		velocity.set(direction.x, direction.y);

		offset.set(defaultOffset.x, carrierOffset.y * .7);
		setSize(defaultSize.x, defaultSize.y);
		this.setMidpoint(x, y);
	}
}

enum ThrowableState {
	DEFAULT;
	PICKUPABLE;
	BEING_CARRIED;
	BEING_THROWN;
}