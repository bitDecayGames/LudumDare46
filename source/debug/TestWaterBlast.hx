package debug;

import flixel.math.FlxPoint;
import flixel.FlxBasic;
import managers.FireManager;
import flixel.group.FlxSpriteGroup;
import entities.PlayerGroup;
import hitbox.HitboxSprite;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import entities.Player;
import screens.GameScreen;
import entities.EnemyFlock;
import entities.Enemy;
import entities.enemies.KingOfPop;
import entities.enemies.RegularAssZombie;
import entities.enemies.HardworkingFirefighter;
import entities.enemies.ConfusedZombie;
import flixel.group.FlxGroup;
import flixel.FlxG;
import managers.HitboxManager;
import entities.WaterSplash;

class TestWaterBlast extends FlxBasic {
	var hitboxMgr:HitboxManager;
	var num:Float = 0;

	public function new(game:GameScreen, hitboxMgr:HitboxManager) {
		super();
		game.add(this);
		this.hitboxMgr = hitboxMgr;
	}

	override function update(delta:Float):Void {
		if (FlxG.mouse.pressed) {
			spawnWater(FlxG.mouse.getWorldPosition());
		}
	}

	function spawnWater(target:FlxPoint) {
		num += 0.5;
		hitboxMgr.addGeneral(new WaterSplash(0.0, 0.0, target.x + Math.sin(num) * 3, target.y + Math.sin(num) * 3));
	}
}
