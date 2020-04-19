package debug;

import flixel.math.FlxRandom;
import entities.Player;
import screens.GameScreen;
import entities.EnemyFlock;
import entities.Enemy;
import entities.enemies.RegularAssZombie;
import entities.enemies.ConfusedZombie;
import flixel.group.FlxGroup;

class TestEnemyFlock {
	var player:Player;
	var flock:EnemyFlock;

	public function new(game:GameScreen) {
		player = new Player(new FlxGroup());
		player.x = 120;
		player.y = 300;
		game.add(player);
		flock = new EnemyFlock(player);
		game.add(flock);

		var e:Enemy;
		var rnd = new FlxRandom();
		for (i in 0...20) {
			if (i % 2 == 0) {
				e = new RegularAssZombie(player);
			} else {
				e = new ConfusedZombie(player);
			}
			e.x = 100 + i * 10;
			e.y = 100 + rnd.float(0, 10);
			flock.add(e);
		}
	}
}
