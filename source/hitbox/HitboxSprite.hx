package hitbox;

import flixel.FlxSprite;

class HitboxSprite extends FlxSprite {
	public var loc:HitboxLocation;

	public function new(hbl:HitboxLocation) {
		super();
		loc = hbl;
		width = hbl.size.x;
		height = hbl.size.y;
		deactivate();
	}

	public function activate() {
		exists = true;
		visible = true;
	}

	public function deactivate() {
		exists = false;
		visible = false;
	}
}