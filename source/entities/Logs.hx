package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;


class Logs extends FlxSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        immovable = true;
        super.loadGraphic(AssetPaths.Logpile__png, true, 32, 48);
        var hurtboxSize:FlxPoint = new FlxPoint(28, 16);
		offset.set(width / 2 - hurtboxSize.x / 2, height - hurtboxSize.y - 2);
        setSize(hurtboxSize.x, hurtboxSize.y);
    }
}