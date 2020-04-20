package entities;

import audio.SoundBankAccessor;
import audio.BitdecaySoundBank;
import managers.HitboxManager;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import hitbox.AttackHitboxes;
import hitbox.HitboxLocation;
import hitbox.HitboxSprite;
import flixel.group.FlxGroup;

class Bullet extends FlxSprite {
	public function new(x:Float, y:Float, targetX:Float, targetY:Float) {
		super(x, y);
		super.loadGraphic(AssetPaths.Bullet__png);
		this.x = x - width / 2.0;
		this.y = y - height / 2.0;
		var distX = targetX - this.x;
		var distY = targetY - this.y;
		acceleration.set(0, 10);
		health = 1;

		velocity.x = (distX - (acceleration.x / 2.0)) / (health);
		velocity.y = (distY - (acceleration.y / 2.0)) / (health);
		updateAngle();
	}

	override public function update(delta:Float):Void {
		updateAngle();
		hurt(delta);
		super.update(delta);
	}

	function updateAngle() {
		angle = velocity.angleBetween(new FlxPoint()) + 90.0;
	}
}
