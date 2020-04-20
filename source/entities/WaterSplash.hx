package entities;

import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class WaterSplash extends FlxSprite {

	var standin:FlxPoint = new FlxPoint();

	public function new(x:Float, y:Float, targetX:Float, targetY:Float) {
		super(x, y);
		super.loadGraphic(AssetPaths.WaterBlast__png, true, 8, 5);
		this.x = x - width / 2.0;
		this.y = y - height / 2.0;
		var rnd = new FlxRandom();
		animation.add("shoot", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 4 + rnd.int(-3, 3));
		animation.play("shoot");
		var distX = targetX - this.x;
		var distY = targetY - this.y;
		acceleration.set(0, 300);
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
		standin.set(0, 0);
		angle = velocity.angleBetween(standin) - 90.0;
	}
}
