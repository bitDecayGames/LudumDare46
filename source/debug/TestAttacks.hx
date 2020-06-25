package debug;

import flixel.addons.ui.FlxUIState;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxPoint;
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
import entities.enemies.Attacker;
import flixel.group.FlxGroup;
import flixel.FlxG;
import managers.HitboxManager;

class TestAttacks {
	var hitboxMgr:HitboxManager;
	var topLeft:FlxPoint = new FlxPoint(0, 0);
	var spacing:Float = 60;
	var perRow:Int = 3;
	var graphicList:Array<FlxGraphicAsset>;

	public function new(game:FlxUIState, hitboxMgr:HitboxManager, center:FlxPoint) {
		this.hitboxMgr = hitboxMgr;
		graphicList = [
			AssetPaths.Zombie__png,
			AssetPaths.Skeleton__png,
			AssetPaths.Cop__png,
			AssetPaths.Jackson__png,
			AssetPaths.Firefighter__png,
			AssetPaths.Bear__png,
			AssetPaths.Necromancer__png,
			AssetPaths.Devil__png,
		];
		for (i in 0...graphicList.length) {
			createAttacker((i % perRow) * spacing + center.x, Math.floor(i / perRow) * spacing + center.y, graphicList[i]);
		}
	}

	private function createAttacker(x:Float, y:Float, graphic:FlxGraphicAsset) {
		var e = new Attacker(hitboxMgr, graphic);
		e.x = x;
		e.y = y;
		trace("create attacker: " + x + ", " + y);
		hitboxMgr.addEnemy(e);
	}
}
