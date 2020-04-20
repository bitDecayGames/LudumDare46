package entities;

import flixel.FlxG;
import flixel.FlxSprite;

class ProgressCover extends FlxSprite {

	public function new() {
		super();
		loadGraphic(AssetPaths.dialFrame__png);
		updateHitbox();
		
		x = FlxG.camera.width / 2 - width + (FlxG.camera.width / 2) / FlxG.camera.zoom;
		y = FlxG.camera.height / 2 - (FlxG.camera.height / 2)  / FlxG.camera.zoom;
		
		scrollFactor.set(0, 0);
	}
}