package screens;

import FmodConstants.FmodSFX;
import FmodConstants.FmodSongs;
import haxefmod.FmodManager;
import haxefmod.flixel.FmodUtilities;
import analytics.Analytics;
import screens.GameScreen;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;

class MainMenuScreen extends FlxUIState {
	static private inline var START = "start_game_btn";
	static private inline var CREDITS = "credits_btn";
	static private inline var EXIT = "exit_btn";

	override public function create():Void {
		_xml_id = "mainMenuScreen";
		super.create();
		FmodManager.PlaySong(FmodSongs.ABattleAhead);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();
	}

	override public function onFocus(){
		super.onFocus();
		FmodManager.UnpauseSong();
	}

	override public function onFocusLost(){
		super.onFocusLost();
		FmodManager.PauseSong();
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case START:
						FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
        				// haxefmod.fmod_create_event_instance_one_shot("MenuSelect");
						// Analytics.send(Analytics.GAME_STARTED);
						FmodUtilities.TransitionToStateAndStopMusic(new GameScreen());
					case CREDITS:
						FmodManager.PlaySoundOneShot(FmodSFX.MenuNavigate);
						// Analytics.send(Analytics.CREDITS);
						FmodUtilities.TransitionToState(new CreditsScreen());
					case EXIT:
						#if !html5
						Sys.exit(0);
						#end
				}
			}
		}
	}
}
