package screens;

import faxe.FaxeUpdater;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;

class GameOverScreen extends FlxUIState {
	static private inline var OKAY = "ok_btn";

	override public function create():Void {
		_xml_id = "gameOverScreen";
		super.create();
		add(new FaxeUpdater());
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case OKAY:
						FlxG.switchState(new MainMenuScreen());
				}
			}
		}
	}
}
