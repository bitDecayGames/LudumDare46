package screens;

import flixel.FlxCamera;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.NightShader;
import managers.HitboxManager;
import audio.SoundBankAccessor;
import transitions.SceneTransitioner;
import audio.BitdecaySoundBank;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import debug.TestEnemyFlock;
import debug.TestKingOfPop;
import debug.TestWaterBlast;
import managers.FireManager;
import managers.ProgressManager;
import managers.EnemySpawnManager;
import cameras.PositionAverager;

class GameScreen extends FlxUIState {
	static private inline var PAUSE = "pause_btn";
	static private inline var RESUME = "resume_game_btn";
	static private inline var QUIT = "quit_btn";

	var filters:Array<BitmapFilter> = [];
	public var shader = new NightShader();

	var fireMgr:FireManager;
	var victoryMgr:ProgressManager;

	public var cameraFocalPoint:PositionAverager;

	public var bitdecaySoundBank:BitdecaySoundBank;
	public var transitioner:SceneTransitioner;
	var transitioning:Bool = false;

	public var paused = false;

	private var firstUnpause = true;

	override public function create():Void {
		_xml_id = "gameScreen";
		super.create();

		bitdecaySoundBank = new BitdecaySoundBank();
		transitioner = new SceneTransitioner();

		bitdecaySoundBank.PlaySong(BitdecaySongs.ZombieFuel);
		// bitdecaySoundBank.PlaySoundLooped(BitdecaySounds.Campfire);

		unpause();

		//
		// KEEP THIS CLASS CLEAN
		//
		// We should maybe use something like:
		// new CameraManager(this);
		// new TreeManager(this);
		// new EnemySpawner(this);
		//
		// and that way this entire class stays relatively clean
		// and we don't end up with a million merge conflicts
		//
		// only you can prevent merge forest conflict fires
		//
		var hitboxMgr = new HitboxManager(this);
		hitboxMgr.setPlayZone(27, 130, 1000, 750);
		hitboxMgr.addTrees();

		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.bgColor = FlxColor.WHITE;
		camera.setFilters(filters);
		camera.zoom = 2;

		cameraFocalPoint = new PositionAverager();
		cameraFocalPoint.addObject(hitboxMgr.getPlayer());
		FlxG.watch.add(hitboxMgr.getPlayer(), "x", "x: ");
		FlxG.watch.add(hitboxMgr.getPlayer(), "y", "y: ");
		add(cameraFocalPoint);
		camera.follow(cameraFocalPoint);

		fireMgr = new FireManager(this, hitboxMgr);
		new EnemySpawnManager(this, hitboxMgr, fireMgr.getSprite());

		victoryMgr = new ProgressManager(this);
		add(victoryMgr);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		bitdecaySoundBank.update();
		transitioner.update();
		fireMgr.update(elapsed);

		if (victoryMgr.hasWon() && !transitioning) {
			fireMgr.disableLose();
			transitioning = true;
			transitioner.TransitionWithMusicFade(new WinScreen());
		}
	}

	public function pause():Void {
		_ui.setMode("pause");
		paused = true;
		bitdecaySoundBank.TransitionToLowPassSong();
	}

	public function unpause():Void {
		_ui.setMode("empty");
		paused = false;
		if (!firstUnpause) {
			bitdecaySoundBank.TransitionToNormalSong();
		}
		firstUnpause = false;
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case PAUSE:
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MenuNavigate);
						pause();
					case RESUME:
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MenuNavigate);
						unpause();
					case QUIT:
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MenuNavigate);
						transitioner.TransitionWithMusicFade(new MainMenuScreen());
				}
			}
		}
	}
}
