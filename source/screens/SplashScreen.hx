package screens;

import hx.concurrent.Future;
import hx.concurrent.executor.Schedule;
import hx.concurrent.executor.Executor;
import com.bitdecaygames.analytics.Analytics;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import flixel.util.FlxColor;

// SpashScreen is the BitDecayGames splash, it will also load the analytics in the background
class SplashScreen extends FlxUIState {
	static private inline var BACKGROUND = "background_btn";
	static private inline var BACKGROUND_2 = "background_2_btn";

	var frame = -1;

	var timer = 0.0;
	var frameDuration = 3.0;

	var exec:Executor;
	var analyticsStarter:TaskFuture<Bool>;

	override public function create():Void {
		_xml_id = "splashScreen";
		super.create();
		nextFrame();
		
		exec = Executor.create();
		analyticsStarter = exec.submit(startAnalytics, Schedule.ONCE(0));
	}

	private function startAnalytics():Bool {
		#if FLX_NO_DEBUG
		Analytics.Init("bf5b8a15f31bd741ffb8e03cf29a6cec", "1759d1fe6cc9f32efdbe6b5d99ad611f36ad3024", false);
		#end

		#if !FLX_NO_DEBUG
		// simulate the initialization
		Sys.sleep(1);
		#end

		return true;
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
		} else if (analyticsStarter.isStopped) {
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
