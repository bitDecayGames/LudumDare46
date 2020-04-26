package screens;

import faxe.FaxeSoundHelper;
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
		FaxeSoundHelper.GetInstance().PlaySong("ABattleAhead");
		// FaxeSoundHelper.GetInstance().PreloadSound("MenuSelect");
		// FaxeSoundHelper.GetInstance().PreloadSound("MenuNavigate");
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FaxeSoundHelper.GetInstance().Update();
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case START:
						FaxeSoundHelper.GetInstance().PlaySound("MenuSelect");
						// Analytics.send(Analytics.GAME_STARTED);
						FaxeSoundHelper.GetInstance().TransitionToStateAndStopMusic(new GameScreen());
					case CREDITS:
						FaxeSoundHelper.GetInstance().PlaySound("MenuNavigate");
						// Analytics.send(Analytics.CREDITS);
						FaxeSoundHelper.GetInstance().TransitionToState(new CreditsScreen());
					case EXIT:
						#if !html5
						Sys.exit(0);
						#end
				}
			}
		}
	}
}
