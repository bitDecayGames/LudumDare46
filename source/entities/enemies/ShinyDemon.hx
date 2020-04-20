package entities.enemies;

import flixel.math.FlxVector;
import hitbox.HitboxLocation;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import managers.HitboxManager;
import entities.Player;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class ShinyDemon extends SmokeyTheBear {
	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		initAnimations(AssetPaths.Devil__png);
		name = "devil";
		personalBubble = 10;
		speed = 120;
		attackDistance = 10;
		maxWaitTime = 0.25;
		maxChaseTime = 5.0;
		hitsOtherEnemies = true;
		randomizeStats();
	}
}
