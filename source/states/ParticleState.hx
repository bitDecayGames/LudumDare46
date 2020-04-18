package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;

class ParticleState extends FlxState
{
	var testSprite:FlxSprite;
	var emitter:FlxEmitter;

	override public function create():Void
	{
		super.create();
		emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 200);
		emitter.makeParticles(4, 6, FlxColor.ORANGE, 200);
		emitter.color.set(FlxColor.YELLOW, FlxColor.RED, FlxColor.BLACK);
		emitter.launchAngle.set(-80, -100);
		emitter.scale.set(0.5, 1, 2, 2.5);
		emitter.alpha.set(1,1,0,0);
		emitter.setSize(25, 25);
		add(emitter);
		emitter.start(false, 0.01);

		// testSprite = new FlxSprite(FlxG.width/2, FlxG.height/2);
		// testSprite.loadGraphic(AssetPaths.test__png);
		//add(testSprite);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
