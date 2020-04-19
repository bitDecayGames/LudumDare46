package managers;

import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;
import screens.GameOverScreen;
import transitions.SceneTransitioner;
import flixel.FlxG;

class FireManager {

    private var fire:Fire;
    private var transitioner:SceneTransitioner;

	public function new(game:GameScreen, x: Float, y: Float) {
        transitioner = game.transitioner;
        fire = new Fire(x, y, 30);
        fire.onFizzle = gameOver;
        game.add(fire);
        fire.start();
    }

    public function getSprite(): FlxSprite {
        return fire.fireArt;
    }

    public function gameOver() {
        trace("game over");
        FlxG.switchState(new GameOverScreen());
        //transitioner.TransitionWithMusicFade(new GameOverScreen());

        // this might be a bad plan since this gets called inside the fire object, 
        // but it seems to be okay
        fire.kill();
    }
}