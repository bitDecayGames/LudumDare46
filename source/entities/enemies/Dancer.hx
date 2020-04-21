package entities.enemies;

import flixel.system.FlxAssets.FlxGraphicAsset;
import managers.HitboxManager;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class Dancer extends Enemy {
	public function new(hitboxMgr:HitboxManager, graphic:FlxGraphicAsset) {
		super(hitboxMgr);
		danceSpeed = 30;
		initAnimations(graphic);
		name = "dancer";
		startDancing(0, true);
		personalBubble = 15;
	}

	override function calculateVelocity() {
		// do nothing so that this guy just stands there and dances
	}
}
