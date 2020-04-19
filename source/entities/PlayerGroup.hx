package entities;

import flixel.math.FlxPoint;
import flixel.FlxG;
import managers.HitboxManager;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

using extensions.FlxObjectExt;

class PlayerGroup extends FlxGroup {
	var hitboxMgr:HitboxManager;

	public var player:Player;
	public var activelyCarrying:Bool = false;
	
	var carryingObject:Throwable;

	public function new(hitboxMgr:HitboxManager) {
		super(0);
		this.hitboxMgr = hitboxMgr;
		player = new Player(this, hitboxMgr);
		add(player);
		hitboxMgr.addGeneral(player);
	}

	public function pickUp(thing:Throwable) {
		carryingObject = thing;
		activelyCarrying = true;
		thing.pickUp(new FlxPoint(thing.width/2, player.offset.y + 29));
		update(0);
		player.hoist();
	}

	public function throwThing() {
		var dir = new FlxPoint();
		if (player.flipX) {
			dir.set(-1, 0);
		} else {
			dir.set(1, 0);
		}

		carryingObject.getThrown(dir.scale(300), 100);
		activelyCarrying = false;
		player.chuck();
	}

	override public function update(delta:Float) {
		if (activelyCarrying) {
			carryingObject.setMidpoint(player.getMidpoint().x, player.getMidpoint().y);
		}
	}
}