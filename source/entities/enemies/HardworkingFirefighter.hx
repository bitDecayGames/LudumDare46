package entities.enemies;

import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxNestedSprite;
import managers.HitboxManager;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.FlxSprite;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class HardworkingFirefighter extends Enemy {
	var firepit:FlxSprite;
	var num:Float = 0;
	var i:Int = 0;
	var isWaterOn:Bool = false;

	public function new(hitboxMgr:HitboxManager, firepit:FlxSprite) {
		super(hitboxMgr);
		this.firepit = firepit;
		super.initAnimations(AssetPaths.Firefighter__png);
		name = "firefighters";
		personalBubble = 50;
		speed = 30;
		attackDistance = 100;
		randomizeStats();
		invulnerableWhileAttacking = false;
	}

	override public function update(delta:Float):Void {
		super.update(delta);
		if (isWaterOn)
			shootWater();
	}

	function moveTowardsFirepit():FlxVector {
		var v = new FlxVector(0, 0);
		if (firepit != null) {
			var target = firepit.getPosition();
			var direction = target.subtract(x, y);
			v.set(direction.x, direction.y);
			v.normalize();
			v.scale(speed);
		}
		return v;
	}

	override function shouldAttack():Bool {
		var p = new FlxPoint(firepit.x + firepit.width / 2.0, firepit.y + firepit.width / 2.0);
		return firepit != null && FlxMath.distanceToPoint(this, p) <= attackDistance;
	}

	function shootWater() {
		i += 1;
		if (i % 3 == 0) {
			num += 0.5;
			hitboxMgr.addGeneral(new WaterSplash(
				flipX ? x : x + width,
				y - frameHeight / 4.0, 
				firepit.x + firepit.width / 2.0 + Math.sin(num) * 3,
				firepit.y + firepit.height / 2.0 + Math.sin(num) * 3));
		}
	}

	override function calculateVelocity() {
		if (enemyState == CHASING) {
			var move = moveTowardsFirepit();
			var keepDistance = keepDistanceFromOtherEnemies();
			velocity.set(move.x + keepDistance.x, move.y + keepDistance.y);
		}
	}

	override private function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
		super.animCallback(name, frameNumber, frameIndex);
		isWaterOn = name == "attack_0" && frameNumber > 0;
		if (name == "attack_0" && frameNumber == 0){
			SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.FiremanWater);
		}
	}
}
