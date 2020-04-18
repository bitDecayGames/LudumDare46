package entities;

import flixel.FlxSprite;

class Tree extends FlxSprite {

	public function new() {
		super();
		super.loadGraphic(AssetPaths.the_larch__jpg);
		scale.set(0.2, 0.2);
		updateHitbox();
		immovable = true;
	}

}