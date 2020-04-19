package managers;

import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;

class FireManager {

    var fire:Fire;
    var fireSpritePoint:FlxSprite;

	public function new(game:GameScreen, x: Float, y: Float) {
        fireSpritePoint = new FlxSprite(x, y, AssetPaths.transparent__png);
        game.add(fireSpritePoint);
        fire = new Fire(x, y, 30);
		game.add(fire);
        fire.start();
    }

    public function getSprite(): FlxSprite {
        return fireSpritePoint;
    }
}