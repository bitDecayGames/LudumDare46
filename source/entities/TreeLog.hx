package entities;

import flixel.FlxSprite;

class TreeLog extends Throwable {

	public function new() {
		super();
		super.loadGraphic(AssetPaths.itemsNobjects__png, true, 30, 40);

		name = "log";
		
		var hurtboxWidth = 23;
		var hurtboxHeight = 12;

		offset.set((width / 2) - (hurtboxWidth / 2), height - hurtboxHeight);
		setSize(hurtboxWidth, hurtboxHeight);

		animation.add("log", [0], 0);
		animation.play("log");

		state = PICKUPABLE;
	}
}