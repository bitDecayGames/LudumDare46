package managers;

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
		var screenPos = fire.fireArt.getMidpoint();
		// var screenPos = hitboxMgr.getPlayer().getMidpoint();
		// trace("Raw pos: " + screenPos);
		// trace("Cam scroll: " + FlxG.camera.scroll);
		screenPos.subtract(FlxG.camera.scroll.x , FlxG.camera.scroll.y );
		// trace("Adjust pos: " + screenPos);
		// trace(FlxG.height);
		// trace(FlxG.width);
		screenPos.x /= FlxG.height;
		screenPos.y /= FlxG.width;
		// trace("Shader pos: " + screenPos);
		game.shader.firePos.value = [screenPos.x, screenPos.y];

	}
}