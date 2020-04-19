package hitbox;

import flixel.FlxSprite;

class HitboxRegistration {
	public var offset:Int;
	public var hitboxFrames:Array<HitboxSprite>;

	public function new(offset:Int, frames:Array<HitboxSprite>) {
		this.offset = offset;
		hitboxFrames = frames;
	}
}