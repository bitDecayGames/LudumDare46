package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class TreeTop extends FlxSprite {

	var hitboxSize:FlxPoint = new FlxPoint(2, 2);
	var hitboxOffset:FlxPoint = new FlxPoint(0, -30);

	public function new() {
		super();
		super.loadGraphic(AssetPaths.Punches__png, true, 96, 96);

		animation.add("hitFromLeft", [0, 1, 2, 3], 10, false);
		animation.add("hitFromRight", [4, 5, 6, 7], 10, false);

		offset.set((width / 2) - (hitboxOffset.x), height - hitboxOffset.y);
		setSize(hitboxSize.x, hitboxSize.y);

		immovable = true;
	}
}