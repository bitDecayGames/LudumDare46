package screens;

import flixel.util.FlxTimer;
import flixel.text.FlxBitmapText;
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

	public var victoryMgr:ProgressManager;

	public var cameraFocalPoint:PositionAverager;

	public var bitdecaySoundBank:BitdecaySoundBank;
	public var transitioner:SceneTransitioner;

	var transitioning:Bool = false;

	public var paused = false;

	private var firstUnpause = true;
	private var punchTreeText:FlxBitmapText;
	private var burnThingsText:FlxBitmapText;
	private var keepItAliveText:FlxBitmapText;

	public var isTreeTextDestroyed = false;
	public var isMainSongPlaying = false;
	public var finalTextTimer:FlxTimer;

	private var enemySpawnManager:EnemySpawnManager;
	private var campfireSound:Int;

	override public function create():Void {
		_xml_id = "gameScreen";
		super.create();

		bitdecaySoundBank = new BitdecaySoundBank();
		transitioner = new SceneTransitioner();

		campfireSound = bitdecaySoundBank.PlaySoundLooped(BitdecaySounds.Campfire);
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
		enemySpawnManager = new EnemySpawnManager(this, hitboxMgr, fireMgr.getSprite());

		// TODO: MW this is just for testing
		// enemySpawnManager.startSpawningEnemies();

		punchTreeText = new FlxBitmapText();
		punchTreeText.x = 540;
		punchTreeText.y = 535;
		punchTreeText.text = "Punch the trees by pressing Space or Left Click";
		add(punchTreeText);

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

	public function destroyTreeText() {
		if (!isTreeTextDestroyed) {
			punchTreeText.destroy();

			burnThingsText = new FlxBitmapText();
			burnThingsText.x = 475;
			burnThingsText.y = 400;
			burnThingsText.text = "Throw things into the fire";
			add(burnThingsText);

			isTreeTextDestroyed = true;
		}
	}

	public function startMainSong() {
		if (!isMainSongPlaying) {
			FlxG.camera.flash(0.5);
			FlxG.camera.shake(0.005, .5);

			burnThingsText.destroy();
			bitdecaySoundBank.StopSoundLooped(campfireSound);
			bitdecaySoundBank.PlaySong(BitdecaySongs.ZombieFuel);

			keepItAliveText = new FlxBitmapText();
			keepItAliveText.x = 485;
			keepItAliveText.y = 400;
			keepItAliveText.text = "DON'T LET IT GO OUT!!!";
			add(keepItAliveText);

			finalTextTimer = new FlxTimer();
			finalTextTimer.start(4, deleteFinalText, 1);

			fireMgr.startFireTimer();
			victoryMgr.startProgressTimer();

			isMainSongPlaying = true;
		}
	}

	private function deleteFinalText(timer:FlxTimer):Void {
		keepItAliveText.destroy();
		enemySpawnManager.startSpawningEnemies();
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
