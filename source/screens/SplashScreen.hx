package screens;

import faxe.Faxe;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import flixel.util.FlxColor;

class SplashScreen extends FlxUIState {
	static private inline var BACKGROUND = "background_btn";
	static private inline var BACKGROUND_2 = "background_2_btn";

	var frame = -1;

	var timer = 0.0;
	var frameDuration = 3.0;

	override public function create():Void {
		_xml_id = "splashScreen";
		super.create();
		nextFrame();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		timer -= elapsed;
		if (timer < 0)
			nextFrame();
	}

	public function nextFrame() {
		frame += 1;
		timer = frameDuration;
		if (frame == 0) {
			_ui.setMode("bdg");
		} else {
			FlxG.switchState(new SplashScreen2());
		}
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case BACKGROUND | BACKGROUND_2:
						nextFrame();
				}
			}
		}
	}
}
