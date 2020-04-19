package screens;

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
		super.create();

		bitdecaySoundBank = new BitdecaySoundBank();
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
						SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MenuNavigate);
						FlxG.switchState(new MainMenuScreen());
				}
			}
		}
	}
}
