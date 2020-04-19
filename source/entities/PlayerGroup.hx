package entities;

import hitbox.HitboxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

using extensions.FlxObjectExt;

class PlayerGroup extends FlxGroup {
	var sortGroup:FlxSpriteGroup;
	var hitboxGroup:FlxTypedGroup<HitboxSprite>;

	var player:Player;
	var savedInstance:FlxSprite;
	var carry:FlxSprite;

	public function new(sortGroup:FlxSpriteGroup, playerHitboxGroup:FlxTypedGroup<HitboxSprite>) {
		super(0);
		this.sortGroup = sortGroup;
		hitboxGroup = playerHitboxGroup;
		player = new Player(this, playerHitboxGroup);
		add(player);
		sortGroup.add(player);
	}

	public function pickUp(thing:FlxSprite) {
		savedInstance = thing;
		thing.kill();
		// TODO: make the over-head sprite
		carry = new TreeLog();
		carry.active = false;
		carry.offset.set(player.offset.x, player.offset.y + 29);
		carry.setSize(player.width, player.height);

		sortGroup.add(carry);
		update(0);
		player.hoist();
	}

	override public function update(delta:Float) {
		if (carry != null) {
			carry.setMidpoint(player.getMidpoint().x, player.getMidpoint().y);
		}
	}
}