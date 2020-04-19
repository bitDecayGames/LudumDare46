package entities.enemies;

import managers.HitboxManager;
import entities.Player;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class CopWithSomethingToProve extends ConfusedZombie {
	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		super.initAnimations(AssetPaths.Cop__png);
		personalBubble = 50;
		speed = 40;
		attackDistance = 150;
		maxWaitTime = 0.5;
		maxChaseTime = 5.0;
		randomizeStats();
	}

	override public function attack():Void {
		super.attack();
		if (enemyState == CHASING) {
			// TODO: spawn a bullet towards the player
		}
	}
}
