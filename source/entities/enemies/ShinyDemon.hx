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
		super.initAnimations(AssetPaths.Devil__png);
		name = "devil";
		personalBubble = 100;
		speed = 90;
		maxWaitTime = 0.5;
		maxChaseTime = 5.0;
		hitsOtherEnemies = true;
		randomizeStats();
	}
}
