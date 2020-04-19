package managers;

import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;

class FireManager {
	var fire:Fire;
	var fireSpritePoint:FlxSprite;

	public function new(game:GameScreen, hitboxMgr:HitboxManager) {
		var fireX = hitboxMgr.getPlayer().getPosition().x;
		var fireY = hitboxMgr.getPlayer().getPosition().y - 80;

		fireSpritePoint = new FlxSprite(fireX, fireY, AssetPaths.transparent__png);
		game.add(fireSpritePoint);
		fire = new Fire(fireX, fireY, 30);
		game.add(fire);
		fire.start();
	}

	public function getSprite():FlxSprite {
		return fireSpritePoint;
	}
}
