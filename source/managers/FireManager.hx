package managers;

import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;

class FireManager {

    var fire:Fire;

	public function new(game:GameScreen, x: Float, y: Float) {
        fire = new Fire(x, y, 30);
		game.add(fire);
        fire.start();
    }

    public function getSprite(): FlxSprite {
        return fire.fireArt;
    }
}