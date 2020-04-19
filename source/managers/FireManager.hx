package managers;

import cameras.CameraUtils;
import flixel.FlxG;
import constants.GameConstants;
import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;
import screens.GameOverScreen;
import transitions.SceneTransitioner;
import flixel.FlxG;

class FireManager {
	var game:GameScreen;
	var fire:Fire;
	var hitboxMgr:HitboxManager;
    var transitioner:SceneTransitioner;
	
	public function new(game:GameScreen, hitboxMgr: HitboxManager) {
		this.game = game;
		this.hitboxMgr = hitboxMgr;
		fire = new Fire(GameConstants.GAME_START_X, GameConstants.GAME_START_Y - 80, 30);
		fire.onFizzle = gameOver;
		hitboxMgr.addGeneral(fire.fireArt);
        transitioner = game.transitioner;
		game.add(fire);
		fire.start();
	}

    public function gameOver() {
        trace("game over");
        FlxG.switchState(new GameOverScreen());
        //transitioner.TransitionWithMusicFade(new GameOverScreen());

        // this might be a bad plan since this gets called inside the fire object, 
        // but it seems to be okay
        fire.kill();
    }

	public function getSprite():FlxSprite {
		return fire.fireArt;
	}

	public function update(delta:Float) {
		var screenPos = CameraUtils.project(fire.fireArt.getMidpoint(), FlxG.camera);
		screenPos.x /= FlxG.width;
		screenPos.y /= FlxG.width; // haxe seems to assume the screen is square with size width x width
		game.shader.firePos.value = [screenPos.x, screenPos.y];

	}
}