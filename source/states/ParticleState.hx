package states;

import flixel.FlxG;
import flixel.FlxState;
import entities.Fire;

class ParticleState extends FlxState
{
	var fire:Fire;

	override public function create():Void
	{
		super.create();

		fire = new Fire(FlxG.width / 2, FlxG.height / 2, 30, null);
		add(fire.emitter);
		fire.start();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		fire.update(elapsed);
	}
}
