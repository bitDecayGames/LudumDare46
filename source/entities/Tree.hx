package entities;

import flixel.FlxSprite;

class Tree extends FlxSprite {

	public function new() {
		super();
		super.loadGraphic(AssetPaths.testTree__png);

		var hurtboxWidth = 42;
		var hurtboxHeight = 22;

		offset.set((width / 2) - (hurtboxWidth / 2), height - hurtboxHeight);
		setSize(hurtboxWidth, hurtboxHeight);

		immovable = true;
	}

}