package screens;

import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;

class MainMenuScreen extends FlxUIState {
	static private inline var START = "start_game_btn";
	static private inline var CREDITS = "credits_btn";
	static private inline var EXIT = "exit_btn";

	override public function create():Void {
		_xml_id = "mainMenuScreen";
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case START:
						FlxG.switchState(new GameScreen());
					case CREDITS:
						FlxG.switchState(new CreditsScreen());
					case EXIT:
						Sys.exit(0);
				}
			}
		}
	}
}
