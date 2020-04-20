package entities.enemies;

import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import managers.HitboxManager;
import entities.Player;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class CopWithSomethingToProve extends ConfusedZombie {
	var lockedAndLoaded = false;

	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		initAnimations(AssetPaths.Cop__png);
		name = "cop";
		personalBubble = 50;
		speed = 40;
		attackDistance = 150;
		maxWaitTime = 0.5;
		maxChaseTime = 5.0;
		randomizeStats();
	}

	override public function attack():Void {
		super.attack();
	}

	function shootBullet() {
		if (lockedAndLoaded) {
			lockedAndLoaded = false;
			var b = new Bullet(this, flipX ? x : x + width, y - frameHeight / 4.0, hitboxMgr.getPlayer().x, hitboxMgr.getPlayer().y);
			hitboxMgr.addEnemyHitbox(b);
			SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.CopShoot);
		}
	}

	override private function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
		super.animCallback(name, frameNumber, frameIndex);
		if (name == "attack_0") {
			if (frameIndex == 41) {
				lockedAndLoaded = true;
			} else if (frameIndex == 43) {
				shootBullet();
			}
		}
	}
}
