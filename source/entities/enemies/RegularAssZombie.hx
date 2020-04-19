package entities.enemies;

import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class RegularAssZombie extends Enemy {
	public function new(player:Player, playerHitboxesGroup:FlxTypedGroup<HitboxSprite>) {
		super(player, playerHitboxesGroup);
		super.initAnimations(AssetPaths.Zombie__png);
		personalBubble = 50;
		speed = 40;
		randomizeStats();
	}

	override function calculateVelocity() {
		super.calculateVelocity();
	}
}
