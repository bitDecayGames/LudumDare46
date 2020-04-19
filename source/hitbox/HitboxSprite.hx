package hitbox;

import flixel.FlxSprite;

class HitboxSprite extends FlxSprite {
	public var loc:HitboxLocation;

	public function new(hbl:HitboxLocation) {
		super();
		// loadGraphic(AssetPaths.debug__png);
		// scale.set(hbl.size.x, hbl.size.y);
		loc = hbl;
		width = hbl.size.x;
		height = hbl.size.y;
		kill();
		visible = false;
	}
}