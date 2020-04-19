package debug;

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

class TestKingOfPop {
	var hitboxMgr:HitboxManager;

	public function new(game:GameScreen) {
		hitboxMgr = new HitboxManager(game);
		var firepit = new FlxSprite(300, 300, AssetPaths.Bush__png);
		game.add(firepit);

		var e:Enemy;
		var rnd = new FlxRandom();
		for (i in 0...20) {
			if (i == 0) {
				e = new KingOfPop(hitboxMgr);
			} else if (i % 2 == 0) {
				e = new RegularAssZombie(hitboxMgr);
			} else {
				e = new ConfusedZombie(hitboxMgr);
			}
			e.x = 200 + i * 40;
			e.y = 200 + rnd.float(0, 10);
			hitboxMgr.addEnemy(e);
		}
	}
}
