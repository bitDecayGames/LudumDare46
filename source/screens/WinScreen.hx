package screens;

import flixel.math.FlxPoint;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import managers.HitboxManager;
import managers.DancePartyManager;

class WinScreen extends FlxUIState {
	static private inline var OKAY = "ok_btn";

	override public function create():Void {
		_xml_id = "winScreen";

		var hb = new HitboxManager(this);
		new DancePartyManager(this, hb, new FlxPoint(FlxG.width / 2.0, FlxG.height / 2.0));

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
					case OKAY:
						FlxG.switchState(new MainMenuScreen());
				}
			}
		}
	}
}
