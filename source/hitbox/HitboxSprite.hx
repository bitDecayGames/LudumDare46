package hitbox;

import flixel.FlxG;
import flixel.FlxSprite;

class HitboxSprite extends FlxSprite {
	public var loc:HitboxLocation;
	public var source:FlxSprite;


	public function new(hbl:HitboxLocation, source:FlxSprite) {
		super();
		loadGraphic(AssetPaths.transparent__png);
		scale.set(hbl.size.x, hbl.size.y);
		loc = hbl;
		moves = false;
		this.source = source;
		width = hbl.size.x;
		height = hbl.size.y;
		kill();
	}
}
