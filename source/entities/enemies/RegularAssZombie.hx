package entities.enemies;

import entities.Player;
import entities.Enemy;

class RegularAssZombie extends Enemy {
	public function new(player:Player) {
		super(player);
		super.initAnimations(AssetPaths.Zombie__png);
		personalBubble = 50;
		speed = 40;
		randomizeStats();
	}

	override function calculateVelocity() {
		super.calculateVelocity();
	}
}
