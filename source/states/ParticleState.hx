package states;

import flixel.FlxG;
import openfl.display.Sprite;
import flixel.FlxSprite;
import flixel.FlxState;

class ParticleState extends FlxState
{
	var testSprite:FlxSprite;

	override public function create():Void
	{
		super.create();

		testSprite = new FlxSprite(FlxG.width/2, FlxG.height/2);
		testSprite.loadGraphic(AssetPaths.test__png);
		add(testSprite);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
