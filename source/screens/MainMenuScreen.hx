package screens;

import audio.BitdecaySound;
import audio.SoundBankAccessor;
import audio.BitdecaySoundBank;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import transitions.SceneTransitioner;

class MainMenuScreen extends FlxUIState {
	static private inline var START = "start_game_btn";
	static private inline var CREDITS = "credits_btn";
	static private inline var EXIT = "exit_btn";

	public var bitdecaySoundBank:BitdecaySoundBank;
	public var transitioner:SceneTransitioner;

	override public function create():Void {
		_xml_id = "mainMenuScreen";
		super.create();
		
		bitdecaySoundBank = new BitdecaySoundBank();
		transitioner = new SceneTransitioner();
		// This is a hack to track the title screen song when we go to the credits scene
		if (FlxG.sound.defaultMusicGroup.sounds.length == 0){
			bitdecaySoundBank.PlaySong(BitdecaySongs.TitleScreen);
		} else {
			bitdecaySoundBank.TrackSong(FlxG.sound.defaultMusicGroup.sounds[0]);
		}

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		transitioner.update();
		bitdecaySoundBank.update();
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case START:
						transitioner.TransitionWithMusicFade(new GameScreen());
					case CREDITS:
						FlxG.switchState(new CreditsScreen());
					case EXIT:
						#if !html5
						Sys.exit(0);
						#end
				}
			}
		}
	}
}
