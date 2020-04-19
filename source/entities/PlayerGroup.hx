package entities;

import flixel.FlxG;
import managers.HitboxManager;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

using extensions.FlxObjectExt;

class PlayerGroup extends FlxGroup {
	var hitboxMgr:HitboxManager;

	public var player:Player;
	var savedInstance:FlxSprite;
	var carry:FlxSprite;

	public function new(hitboxMgr:HitboxManager) {
		super(0);
		this.hitboxMgr = hitboxMgr;
		player = new Player(this, hitboxMgr);
		// Set start position
		player.setPosition(FlxG.width / 2, FlxG.height / 2);
		add(player);
		hitboxMgr.addGeneral(player);
	}

	public function pickUp(thing:FlxSprite) {
		savedInstance = thing;
		thing.kill();
		// TODO: make the over-head sprite
		carry = new TreeLog();
		carry.active = false;
		carry.offset.set(player.offset.x, player.offset.y + 29);
		carry.setSize(player.width, player.height);

		hitboxMgr.addGeneral(carry);
		update(0);
		player.hoist();
	}

	override public function update(delta:Float) {
		if (carry != null) {
			carry.setMidpoint(player.getMidpoint().x, player.getMidpoint().y);
		}
	}
}