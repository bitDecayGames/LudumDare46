package entities;

import hitbox.HitboxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

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
		player = new Player(playerHitboxGroup);
		add(player);
		sortGroup.add(player);
	}
}