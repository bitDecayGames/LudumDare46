package debug;

import entities.Player;
import screens.GameScreen;
import entities.EnemyFlock;
import entities.enemies.RegularAssZombie;

class TestEnemyFlock {
	var player:Player;
	var flock:EnemyFlock;

	public function new(game:GameScreen) {
		player = new Player();
		player.x = 120;
		player.y = 300;
		game.add(player);
		flock = new EnemyFlock(player);
		game.add(flock);

		var e:RegularAssZombie;
		for (i in 0...20) {
			e = new RegularAssZombie(player);
			e.x = 100 + i * 10;
			e.y = 100;
			flock.add(e);
		}
	}
}
