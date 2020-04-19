package managers;

import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;

class FireManager {
	var fire:Fire;

	public function new(game:GameScreen, hitboxMgr:HitboxManager) {
		var fireX = hitboxMgr.getPlayer().getPosition().x;
		var fireY = hitboxMgr.getPlayer().getPosition().y - 80;

		fire = new Fire(fireX, fireY, 30);
		game.add(fire);
		fire.start();
	}

	public function getSprite():FlxSprite {
		return fire.fireArt;
	}
}
