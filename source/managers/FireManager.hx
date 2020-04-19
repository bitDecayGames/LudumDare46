package managers;

import constants.GameConstants;
import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;

class FireManager {
	var fire:Fire;

	public function new(game:GameScreen, hitboxMgr: HitboxManager) {
		fire = new Fire(GameConstants.GAME_START_X, GameConstants.GAME_START_Y - 80, 30);
		game.add(fire);
		fire.start();
	}

	public function getSprite():FlxSprite {
		return fire.fireArt;
	}
}
