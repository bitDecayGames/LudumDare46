package screens;

import faxe.FaxeSoundHelper;
import faxe.FaxeUpdater;
import flixel.math.FlxPoint;
import entities.Logs;
import flixel.util.FlxColor;
import entities.FireArt;
import entities.Fire;
import audio.BitdecaySoundBank;
import audio.SoundBankAccessor;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;

class CreditsScreen extends FlxUIState {
	static private inline var BACK = "back_btn";

	public var bitdecaySoundBank:BitdecaySoundBank;

	override public function create():Void {
		_xml_id = "creditsScreen";
		bgColor = FlxColor.BLACK;
		super.create();
		add(new FaxeUpdater());

		bitdecaySoundBank = new BitdecaySoundBank();

		var pos:FlxPoint = new FlxPoint(300, 550);

		var logs:Logs = new Logs(pos.x, pos.y);
		logs.scale.set(5, 5);
		add(logs);

		var fire:FireArt = new FireArt(pos.x, pos.y, null);
		fire.animation.play("regular");
		fire.scale.set(5, 5);
		add(fire);

		FaxeSoundHelper.GetInstance().PreloadSound("MenuSelect");
		FaxeSoundHelper.GetInstance().PreloadSound("MenuNavigate");
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button = Std.downcast(sender, FlxUIButton);
			if (button != null) {
				switch (button.name) {
					case BACK:
						FaxeSoundHelper.GetInstance().PlaySound("MenuNavigate");
						FlxG.switchState(new MainMenuScreen());
				}
			}
		}
	}
}
