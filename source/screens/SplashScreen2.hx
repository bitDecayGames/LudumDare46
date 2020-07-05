package screens;

import com.bitdecay.analytics.Bitlytics;
import com.bitdecay.net.influx.InfluxDB;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;

class SplashScreen2 extends FlxUIState {
	static private inline var BACKGROUND = "background_btn";
	static private inline var BACKGROUND_2 = "background_2_btn";

	var frame = -1;

	var timer = 0.0;
	var frameDuration = 3.0;

	override public function create():Void {
		_xml_id = "splashScreen";
		super.create();
		nextFrame();
		var sender = new InfluxDB(
			"https://us-west-2-1.aws.cloud2.influxdata.com/api/v2/write",
			"13ecc65d2303c6d7",
			"05f4043ec49f9000",
			"sdtsiDLh01M3-BIx_YHq_66RSm0qwgu7GZVp2sIAhAx2gAYSjVg0uzKEa6yyTrZMRNvmhDVLsVh6nSB-HkcZ5w==");
		Bitlytics.Init("Brawnfire", sender);
		Bitlytics.Instance().NewSession();
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
			_ui.setMode("ld");
		} else {
			FlxG.switchState(new MainMenuScreen());
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
