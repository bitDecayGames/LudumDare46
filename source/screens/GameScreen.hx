package screens;

import audio.BitdecaySoundBank;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import debug.TestEnemyFlock;
import managers.FireManager;
import managers.GameManager;

class GameScreen extends FlxUIState {
	static private inline var PAUSE = "pause_btn";
	static private inline var RESUME = "resume_game_btn";
	static private inline var QUIT = "quit_btn";

	public var bitdecaySoundBank:BitdecaySoundBank;

	public var paused = false;
	private var firstUnpause = true;

	var gameManager:GameManager;

	override public function create():Void {
		_xml_id = "gameScreen";
		super.create();

		bitdecaySoundBank = new BitdecaySoundBank();
		bitdecaySoundBank.PlaySong(BitdecaySongs.ZombieFuel);

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
		new TestEnemyFlock(this);
		// gameManager = new GameManager(this);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		// TODO Eventually remove this check.
		if (gameManager != null) {
			gameManager.update(elapsed);
		}
		if (FlxG.keys.justPressed.P) {
			bitdecaySoundBank.PlaySound(BitdecaySounds.MachoManThrowPunch);
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
		if (!firstUnpause){
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
						pause();
					case RESUME:
						unpause();
					case QUIT:
						FlxG.switchState(new MainMenuScreen());
				}
			}
		}
	}
}
