package hitbox;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;

class HitboxSprite extends FlxSprite {
	public var loc:HitboxLocation;
	public var source:FlxSprite;
	public var name:String;

	var thingsHit:Map<FlxObject, Bool> = [];

	public function new(?hbl:HitboxLocation, ?source:FlxSprite) {
		super();
		if (hbl != null && source != null) {
			loadGraphic(AssetPaths.transparent__png);
			name = "hitbox";
			scale.set(hbl.size.x, hbl.size.y);
			loc = hbl;
			moves = false;
			this.source = source;
			width = hbl.size.x;
			height = hbl.size.y;
			kill();
		}
	}

	public function hasHit(other:FlxObject):Bool {
		return thingsHit.exists(other);
	}

	public function registerHit(other:FlxObject) {
		thingsHit[other] = true;
	}

	public function clearHits() {
		thingsHit.clear();

		// MW make sure to ignore the parent of this hitbox
		if (source != null) {
			registerHit(source);
		}
	}
}
