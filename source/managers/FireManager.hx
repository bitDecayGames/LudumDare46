package managers;

import cameras.CameraUtils;
import flixel.FlxG;
import constants.GameConstants;
import flixel.FlxSprite;
import entities.Fire;
import entities.Logs;
import screens.GameScreen;
import screens.GameOverScreen;
import transitions.SceneTransitioner;
import flixel.FlxG;

class FireManager {
	var game:GameScreen;
	var fire:Fire;
	var hitboxMgr:HitboxManager;
    var transitioner:SceneTransitioner;
    var logs:Logs;
	var cantLose:Bool = false;
	
	public function new(game:GameScreen, hitboxMgr: HitboxManager) {
		this.game = game;
        this.hitboxMgr = hitboxMgr;
        var x:Float = GameConstants.GAME_START_X;
        var y:Float = GameConstants.GAME_START_Y - 80;

        logs = new Logs(x, y);
        //game.add(logs);
        hitboxMgr.addGeneral(logs);

        fire = new Fire(game.shader, x, y, 30);
		fire.onFizzle = gameOver;
		hitboxMgr.addFire(fire.fireArt);
        transitioner = game.transitioner;
		game.add(fire);
        fire.start();

	}

	public function disableLose() {
		cantLose = true;
	}

    public function gameOver() {
		if (cantLose) {
			return;
		}
        trace("game over");
        // FlxG.switchState(new GameOverScreen());
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
		screenPos.y /= FlxG.height;
		game.shader.firePos.value = [screenPos.x, screenPos.y];
	}
}