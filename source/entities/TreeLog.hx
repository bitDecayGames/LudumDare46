package entities;

import flixel.FlxSprite;

class TreeLog extends FlxSprite {

	public function new() {
		super();
		super.loadGraphic(AssetPaths.itemsNobjects__png, true, 30, 40);
		
		var hurtboxWidth = 24;
		var hurtboxHeight = 14;

		offset.set((width / 2) - (hurtboxWidth / 2), height - hurtboxHeight);
		setSize(hurtboxWidth, hurtboxHeight);

		animation.add("log", [0], 0);
		animation.play("log");
		drag.set(100, 100);
	}

}