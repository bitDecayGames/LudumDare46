package hitbox;

import flixel.math.FlxPoint;

class HitboxLocation {
	public var size:FlxPoint;
	public var offset:FlxPoint;

	public function new(width:Int, height:Int, xOffset:Int, yOffset:Int) {
		size = FlxPoint.get().set(width, height);
		offset = FlxPoint.get().set(xOffset, yOffset);
	}
}