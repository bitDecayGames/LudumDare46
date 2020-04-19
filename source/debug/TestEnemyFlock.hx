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
import entities.enemies.RegularAssZombie;
import entities.enemies.HardworkingFirefighter;
import entities.enemies.ConfusedZombie;
import flixel.group.FlxGroup;
import flixel.FlxG;

class TestEnemyFlock {
	var player:Player;
	var flock:EnemyFlock;
	var playerHitboxes:FlxTypedGroup<HitboxSprite>;

	public function new(game:GameScreen) {
		FlxG.debugger.drawDebug = true;
		playerHitboxes = new FlxTypedGroup<HitboxSprite>();
		game.add(playerHitboxes);
		player = new Player(new PlayerGroup(new FlxSpriteGroup(0), new FlxTypedGroup<HitboxSprite>(0)), playerHitboxes);
		player.x = 120;
		player.y = 300;
		game.add(player);
		flock = new EnemyFlock(player);
		game.add(flock);

		var firepit = new FlxSprite(300, 300, AssetPaths.Bush__png);
		game.add(firepit);

		var e:Enemy;
		var rnd = new FlxRandom();
		for (i in 0...3) {
			if (i % 5 == 0) {
				e = new HardworkingFirefighter(player, firepit, playerHitboxes);
			} else if (i % 2 == 0) {
				e = new RegularAssZombie(player, playerHitboxes);
			} else {
				e = new ConfusedZombie(player, playerHitboxes);
			}
			e.x = 100 + i * 10;
			e.y = 100 + rnd.float(0, 10);
			flock.add(e);
		}
	}
}
