package managers;

import haxefmod.FmodManager;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import analytics.Analytics;
import cameras.CameraUtils;
import flixel.FlxG;
import constants.GameConstants;
import flixel.FlxSprite;
import entities.Fire;
import entities.Logs;
import entities.Throwable;
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
        hitboxMgr.addGeneral(logs);

        fire = new Fire(game.shader, x, y, 8);
        fire.onFizzle = gameOver;
        fire.setOnConsume(consume);
		game.cameraFocalPoint.addObject(fire.fireArt);

		hitboxMgr.addFire(fire.fireArt);
        transitioner = game.transitioner;
		game.add(fire);
        fire.start();

	}

	public function disableLose() {
		cantLose = true;
	}

    public function consume(thing:Throwable) {
        trace("consume in firemanager");
        if (!thing.isOnFire()) {
            thing.upInFlames();


            var thingFire:Fire = new Fire(
                null, 
                thing.x + thing.xOffretForFireSpawn(),
                thing.y + thing.yOffretForFireSpawn(), 
                5
            );
            var fullyConsume:Void->Void = function () {
                thing.kill();
            }
            thingFire.onFizzle = fullyConsume;
            thingFire.alwaysBurns = true;

            // We don't use addFire here because you shouldn't be able to throw things into this fire
            hitboxMgr.addGeneral(thingFire.fireArt);
            game.add(thingFire);
            thingFire.startFireTimer();
            thingFire.start();
        }
    }

    public function startFireTimer() {
		fire.startFireTimer();
	}

    public function gameOver() {
		if (cantLose) {
			return;
		}
        trace("game over");
	//Analytics.send(Analytics.GAME_LOSE);
    // FlxG.switchState(new GameOverScreen());
		FlxG.mouse.visible = true;
        // FmodManager.TransitionToStateAndStopMusic(new GameOverScreen());

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
