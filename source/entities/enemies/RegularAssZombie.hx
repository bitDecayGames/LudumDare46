package entities.enemies;

import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import actions.Actions;
import flixel.FlxSprite;
import entities.Player;
import entities.Enemy;

class RegularAssZombie extends Enemy {
	public function new(player:Player) {
		super(player);
		super.initAnimations(AssetPaths.Zombie__png);
		personalBubble = 100;
	}

	override function calculateVelocity() {
		super.calculateVelocity();
	}
}
