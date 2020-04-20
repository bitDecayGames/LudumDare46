package entities.enemies;

import managers.HitboxManager;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class SpookySpookySkeleton extends Enemy {
	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		super.initAnimations(AssetPaths.Skeleton__png);
		name = "skeleton";
		personalBubble = 50;
		speed = 40;
		randomizeStats();
	}
}
